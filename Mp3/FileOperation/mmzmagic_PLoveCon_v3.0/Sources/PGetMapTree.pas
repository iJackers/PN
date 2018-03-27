unit PGetMapTree;
{
 代码编写: 马敏钊
 日期：  20050509
 功能描述：对树的内存封装
     提供建树的方法 用本类建的树皆可插入到别的树内
 }

interface

uses
  SysUtils, Classes, DB, ADODB, ComCtrls;
type
  {树结构的抽象}
  TBaseTreemap = class
    Id: string;
    Cpt: string;
    SelfIdx: Integer;
    parentid: string;
  end;
  TAfterAddNodeEvent = procedure(TreeNote: TObject; IAddData: TBaseTreemap) of object;
  TMyTreeNode = record
    Id: string;
    Caption: string;
    Level: Integer;
    Data: Pointer; //指向自身的指针
    Mapdata: TBaseTreemap; //抽象数据指针
  end;
  PMyTree = ^TMyTree;
  TMyTree = record
    Node: TMyTreeNode;
    Parent: PMyTree;
    Child: array of PMyTree;
  end;
  TMapTree = class
  protected
    FQuery: TADOQuery;
    FList: TStringList;
    FAfterAddNode: TAfterAddNodeEvent;
    {内存树}
    Ftree: TMyTree;
    {读取MAP数据源}
    function GetDateSource(ItabName, IidField, ICaptionFIeld, IparentNOField, ILeverField: string): TStringList; overload;
    {根据ID号获取父接点}
    function GetParentNote(IMapNote: PMyTree; Iid: string): PMyTree;
    {释放对象}
    {释放内存数据}
    procedure DisPoseMemTree(IMemnode: PMyTree);
    procedure ClearMapData;
  public
    {返回生成好的map树}
    function GetMapTree(ItabName, IidField, ICaptionFIeld, IparentNOField, ILeverField: string): PMyTree; overload;
    {根据内存数据生成树}
    procedure CreateTree(ItreeViw: TTreeView; t: PMyTree; pNode: TTreeNode); overload;
    constructor Create(IDateOPTer: Tadoquery);
    destructor Destroy; override;
    {生成内存树}
    function CreateMemTree(IDts: TStringList): PMyTree;
    property OnafterAddNode: TAfterAddNodeEvent read FAfterAddNode write FAfterAddNode;
  end;
implementation

procedure TMapTree.CreateTree(ItreeViw: TTreeView; t: PMyTree; pNode: TTreeNode);
var
  node: TTreeNode;
  i: integer;
begin
  for i := 0 to length(t.child) - 1 do begin
    if Length(t.child[i].child) > 0 then begin
      node := ItreeViw.Items.AddChildObject(pNode, t.Child[i].Node.Caption, t.Child[i].Node.Mapdata);
      if assigned(FAfterAddNode) then
        FAfterAddNode(Node, TBaseTreemap(node.data));
      CreateTree(ItreeViw, t.child[i], node);
    end
    else begin
      node := ItreeViw.Items.AddChildObject(pNode, t.Child[i].Node.Caption, t.Child[i].Node.Mapdata);
      if assigned(FAfterAddNode) then
        FAfterAddNode(Node, TBaseTreemap(node.data));
    end;
  end;
end;


procedure TMapTree.ClearMapData;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    FList.Objects[i].Free;
  FList.Clear;
  DisPoseMemTree(@Ftree);
end;

constructor TMapTree.Create(IDateOPTer: Tadoquery);
begin
  FQuery := IDateOPTer;
  FList := TStringList.Create;
end;

function TMapTree.CreateMemTree(IDts: TStringList): PMyTree;
var
  I: Integer;
  Note: PMyTree;
  TreeNote: PMyTree;
begin
  FList.Free;
  FList := IDts;
  with IDts do begin
    for I := 0 to Count - 1 do begin // Iterate
      if (Objects[i] as TBaseTreemap).parentid = '-1' then
        note := nil
      else
        Note := GetParentNote(@Ftree, (Objects[i] as TBaseTreemap).parentid);
      if Note = nil then begin
        SetLength(Ftree.Child, length(Ftree.Child) + 1);
        New(TreeNote);
        TreeNote^.Node.Id := (Objects[i] as TBaseTreemap).Id;
        TreeNote^.Node.Caption := (Objects[i] as TBaseTreemap).Cpt;
        TreeNote^.Node.Level := (Objects[i] as TBaseTreemap).SelfIdx;
        TreeNote^.Node.Data := TreeNote;
        TreeNote^.Parent := nil;
        TreeNote^.Node.Mapdata := (Objects[i] as TBaseTreemap);
        Ftree.Child[High(Ftree.Child)] := TreeNote;
      end
      else begin
        SetLength(Note.Child, length(Note.Child) + 1);
        New(TreeNote);
        TreeNote^.Node.Id := (Objects[i] as TBaseTreemap).Id;
        TreeNote^.Node.Caption := (Objects[i] as TBaseTreemap).Cpt;
        TreeNote^.Node.Level := (Objects[i] as TBaseTreemap).SelfIdx;
        TreeNote^.Node.Data := TreeNote;
        TreeNote^.Parent := Note;
        TreeNote^.Node.Mapdata := (Objects[i] as TBaseTreemap);
        note.Child[High(Note.Child)] := TreeNote;
      end;
    end; // for
  end;
  Result := @Ftree;
end;

destructor TMapTree.Destroy;
begin
  ClearMapData;
  FList.Free;
  inherited;
end;

procedure TMapTree.DisPoseMemTree(IMemnode: PMyTree);
var
  I: Integer;
begin
  for I := 0 to Length(iMemNode^.Child) - 1 do
    if Length(IMemnode^.Child) > 0 then begin
      DisPoseMemTree(IMemnode^.Child[i]);
      Dispose(IMemnode^.Child[i]);
    end
    else
      Dispose(IMemnode^.Child[i]);
end;

function TMapTree.GetDateSource(ItabName, IidField, ICaptionFIeld, IparentNOField, ILeverField: string): TStringList;
var
  Ltep: TBaseTreemap;
begin
  ClearMapData;
  with FQuery do begin
    Close;
    SQL.Text := Format('select * from %s order by %s,%s', [ItabName, IparentNOField, ILeverField]);
    Open;
    if FQuery.RecordCount > 0 then begin
      first;
      while not Eof do begin
        Ltep := TBaseTreemap.Create;
        Ltep.Id := FieldValues[IidField];
        Ltep.Cpt := FieldValues[ICaptionFIeld];
        Ltep.SelfIdx := FieldValues[ILeverField];
        Ltep.parentid := FieldValues[IparentNOField];
        FList.AddObject(Ltep.id, Ltep);
        Next;
      end; // while
    end;
  end; // with
  Result := FList;
end;

function TMapTree.GetMapTree(ItabName, IidField, ICaptionFIeld, IparentNOField, ILeverField: string): PMyTree;
begin
  Result := CreateMemTree(GetDateSource(ItabName, IidField, ICaptionFIeld, IparentNOField, ILeverField));
end;

function TMapTree.GetParentNote(IMapNote: PMyTree; Iid: string): PMyTree;
var
  I: Integer;
begin
  Result := nil;
  if IMapNote^.Node.Id = Iid then
    Result := IMapNote;
  if Result <> nil then exit;
  for I := 0 to Length(IMapNote^.Child) - 1 do begin
    Result := GetParentNote(IMapNote^.Child[i], Iid);
    if Result <> nil then exit;
  end;
end;

end.

