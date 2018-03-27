Unit PBaseTree;
{
��Ԫ����PMyExtentArcMapControl
�����ߣ�������
�������ڣ�20050409
�ࣺTBaseTreemap ��TXZDMapTab, TGisTreeDataSource
����������
   TBaseTreemap �����ṹ��һ�������������������Ҫ����Ϣ
   TBaseTree�ṩ�˲������Ļ�������
}
Interface
Uses Classes, SysUtils, ComCtrls;
Type
  {���ṹ�ĳ���}
  TBaseTreemap = Class
    Id: String; //�Լ���ID
    Cpt: String; //����
    SelfIdx: Integer; //ͬ������
    parentid: String; //��ID
  End;
  TCreateTreeNoteEvent = Procedure(TreeNote: TTreeNode; BaseTreeMap: TBaseTreemap) Of Object;
  TBaseTree = Class
  Protected
    FTree: TTreeView;
    FOnCreateTreeNoteEvent: TCreateTreeNoteEvent;
    Procedure DoCompost(IBase, IInobj: TStringList); Virtual; Abstract;
  Public
    {������}
    Procedure CreateTree(IDateSource: TStringList); Virtual;
    {��ȡ���ӵ�}
    Function GetParentNote(Iid: String): TTreeNode;
    {�����ͬʱ�ͷ�Data}
    Procedure ClearTree;
    {��������}
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
  //�����ʵ�ֹ���
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
      //��Ϊ�ռ�С��ĸ��ӵ�������� ʹ���±ߵ��㷨
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

