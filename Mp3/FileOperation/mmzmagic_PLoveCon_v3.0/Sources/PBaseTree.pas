Unit PBaseTree;
{
单元名：PMyExtentArcMapControl
创建者：马敏钊
创建日期：20050409
类：TBaseTreemap ，TXZDMapTab, TGisTreeDataSource
功能描述：
   TBaseTreemap 是树结构的一个抽象类包含创建树需要的信息
   TBaseTree提供了操作树的基本方法
}
Interface
Uses Classes, SysUtils, ComCtrls;
Type
  {树结构的抽象}
  TBaseTreemap = Class
    Id: String; //自己的ID
    Cpt: String; //标题
    SelfIdx: Integer; //同级索引
    parentid: String; //父ID
  End;
  TCreateTreeNoteEvent = Procedure(TreeNote: TTreeNode; BaseTreeMap: TBaseTreemap) Of Object;
  TBaseTree = Class
  Protected
    FTree: TTreeView;
    FOnCreateTreeNoteEvent: TCreateTreeNoteEvent;
    Procedure DoCompost(IBase, IInobj: TStringList); Virtual; Abstract;
  Public
    {创建树}
    Procedure CreateTree(IDateSource: TStringList); Virtual;
    {获取父接点}
    Function GetParentNote(Iid: String): TTreeNode;
    {清除树同时释放Data}
    Procedure ClearTree;
    {排序数据}
    Function CompostitList(Ilist: TStringList): TStringList;
    Constructor Create(ITree: TTreeView);
    Destructor Destroy; Override;
  End;
Implementation

{ TBaseTree }

Procedure TBaseTree.ClearTree;
Var
  I: Integer;
Begin
  For I := 0 To Ftree.Items.Count - 1 Do
    If Ftree.Items[i].Data <> Nil Then
      TObject(Ftree.Items[i].Data).Free;
  Ftree.Items.Clear;
End;

Function TBaseTree.CompostitList(Ilist: TStringList): TStringList;
Begin
  Result := TStringList.Create;
  If Ilist.Count <= 0 Then exit;
  //排序的实现过程
  DoCompost(Result, Ilist);
  Ilist.Free;
End;

Constructor TBaseTree.Create(ITree: TTreeView);
Begin
  FTree := ITree;
End;

Procedure TBaseTree.CreateTree(IDateSource: TStringList);
Var
  I: Integer;
  Note: TTreeNode;
Begin
  FTree.Items.Clear;
  FTree.Items.BeginUpdate;
  Try
    Try
      With IDateSource Do Begin
      //因为收集小软的父接点特殊情况 使用下边的算法
        For I := 0 To Count - 1 Do Begin // Iterate
          Note := GetParentNote((Objects[i] As TBaseTreemap).parentid);
          If Note = Nil Then Begin
            Note := FTree.Items.Add(Nil, (Objects[i] As TBaseTreemap).Cpt);
            Note.Data := (Objects[i] As TBaseTreemap);
          End
          Else Begin
            note := FTree.Items.AddChild(Note, (Objects[i] As TBaseTreemap).Cpt);
            Note.Data := (Objects[i] As TBaseTreemap);
          End;
          If assigned(FOnCreateTreeNoteEvent) Then
            FOnCreateTreeNoteEvent(Note, (Objects[i] As TBaseTreemap));
        End; // for
      End;
    Except
      Raise;
    End;
  Finally
    FTree.Items.EndUpdate;
  End;
End;

Destructor TBaseTree.Destroy;
Begin
  Inherited;
End;

Function TBaseTree.GetParentNote(Iid: String): TTreeNode;
Var
  I: Integer;
Begin
  Result := Nil;
  For I := 0 To FTree.Items.Count - 1 Do
    If TBaseTreemap(FTree.Items[i].Data).Id = Iid Then Begin
      Result := FTree.Items[i];
      exit;
    End; // for
End;

End.

