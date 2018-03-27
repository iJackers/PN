Unit PMyColoctTreeImp;

Interface
Uses PBaseTree, ComCtrls, Classes, PFormatDefine, PGetMapTree;
Type
  TMyColocTTreemap = Class(TBaseTreemap)
    MidxPos: Cardinal;
    MFmt: RFileContentFmt;
  End;
  TMyColoctTreeCtl = Class
  Private
    Ftree: TTreeView;
  Protected
    Procedure DoCompost(IBase, IInobj: TStringList);
    Procedure OnCreateNote(TreeNote: TObject; IbaseImg: TBaseTreemap);
  Public
    FmemTree: TMapTree;
    Function GetNoteWithID(iid: Cardinal): TTreeNode;
    {��������}
    Function CompostitList(Ilist: TStringList): TStringList;
    Procedure CreateTree(IDateSource: TStringList);
    Constructor Create(ITree: TTreeView);
    Destructor Destroy; Override;
  End;
Implementation
Uses SysUtils;
{ TMyColoctTreeCtl }

Function TMyColoctTreeCtl.CompostitList(Ilist: TStringList): TStringList;
Begin
  Result := TStringList.Create;
  If Ilist.Count <= 0 Then exit;
  //�����ʵ�ֹ���
  DoCompost(Result, Ilist);
  Ilist.Free;
End;

Constructor TMyColoctTreeCtl.Create(ITree: TTreeView);
Begin
  FmemTree := TMapTree.Create(Nil);
  FmemTree.OnafterAddNode := OnCreateNote;
  FTree := ITree;
End;

Procedure TMyColoctTreeCtl.CreateTree(IDateSource: TStringList);
Begin
  FmemTree.CreateTree(Ftree, FmemTree.CreateMemTree(IDateSource), Nil);
End;

Destructor TMyColoctTreeCtl.Destroy;
Begin
  Ftree.Items.Clear;
  FmemTree.Free;
  Inherited;
End;

{Procedure TMyColoctTreeCtl.DoCompost(IBase, IInobj: TStringList);
Var
  I, Lcount: Integer;
  IsPro: boolean;
Begin
  IBase.AddObject(IInobj.Strings[0], IInobj.Objects[0]); //��1���ȷŽ�ȥ
  //��2����ʼѭ�������һ��
  For I := 1 To IInobj.Count - 1 Do Begin // Iterate
    //ѭ���ж�parentid�Ƿ����һ����С
    Lcount := 0;
    IsPro := False;
    Repeat
      //�������һ����С �Ͳ嵽�Ǹ�ǰ��
      If (IInobj.Objects[i] As TMyColocTTreemap).MFmt.MParentId < (IBase.objects[lCount] As TMyColocTTreemap).MFmt.MParentId Then Begin
        IBase.InsertObject(Lcount, IInobj.Strings[i], IInobj.Objects[i]);
        IsPro := True;
        break;
      End
      Else inc(Lcount); //�����ж���һ��
    Until LCount = IBase.Count;
    If Not IsPro Then //���û�б�ǰ�ߵ�С�ͼӵ����
      IBase.AddObject(IInobj.Strings[i], IInobj.Objects[i]);
  End; // for
End;
}

Procedure TMyColoctTreeCtl.DoCompost(IBase, IInobj: TStringList);
Var
  Lcount: Integer;
  IParentNode, ISelfNode: TMyColocTTreemap;
Begin
  While IInobj.Count > 0 Do Begin
    //��ȡ1���ڵ㣨�׽ڵ㣩
    ISelfNode := IInobj.Objects[0] As TMyColocTTreemap;
    //�ж��Ƿ��и��ڵ�
    If ISelfNode.parentid = '0' Then Begin
      IBase.AddObject(ISelfNode.parentid, ISelfNode);
      IInobj.Delete(IInobj.IndexOfObject(ISelfNode));
    End
    Else Begin //�����
      Lcount := IInobj.IndexOf(ISelfNode.parentid);
      If Lcount = -1 Then Begin //�����-1��ô˵�����ڵ��Ѿ����ֱ������Լ�
        IBase.AddObject(ISelfNode.parentid, ISelfNode);
        IInobj.Delete(IInobj.IndexOfObject(ISelfNode));
        Continue;
      End
      Else Begin
        IParentNode := IInobj.Objects[lCount] As TMyColocTTreemap;
        //�����ж��Ƿ񸸽ڵ㻹�и��ڵ�
        Repeat
          If IParentNode.parentid <> '0' Then Begin
            Lcount := IInobj.IndexOf(IParentNode.parentid);
            If Lcount = -1 Then break;
            ISelfNode := IParentNode;
            IParentNode := IInobj.Objects[lcount] As TMyColocTTreemap;
          End;
        Until IParentNode.parentid = '0';
        If IBase.IndexOfObject(IParentNode) > -1 Then Begin
          IBase.AddObject(ISelfNode.parentid, ISelfNode);
          IInobj.Delete(IInobj.IndexOfObject(ISelfNode));
        End
        Else Begin
          IBase.AddObject(IParentNode.parentid, IParentNode);
          IInobj.Delete(IInobj.IndexOfObject(IParentNode));
        End;
      End;
    End;
  End; // while
End;

Function TMyColoctTreeCtl.GetNoteWithID(iid: Cardinal): TTreeNode;
Var
  I, X: Integer;
Begin
  Result := Nil;
  x := FTree.Items.Count;
  For I := x - 1 Downto 0 Do
    If TMyColocTTreemap(FTree.Items[i].Data).MIdxPos = Iid Then Begin
      Result := FTree.Items[i];
      Exit;
    End;
End;

Procedure TMyColoctTreeCtl.OnCreateNote(TreeNote: TObject; IbaseImg: TBaseTreemap);
Begin
  (TreeNote As TTreeNode).ImageIndex := (IbaseImg As TMyColocTTreemap).MFmt.Mkind;
End;

End.

