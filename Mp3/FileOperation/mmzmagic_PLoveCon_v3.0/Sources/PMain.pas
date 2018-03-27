///////////////////////////////////////////////////////////////////////////////
//此单元为收集小软实现单元                                                  //
//建立日期为2004年9月26日                                                  //
//当前版本号为v1.0                                                        //
//创建人mmzmagic   QQ 22900104   有啥意见一起讨论哈                      //
//////////////////////////////////////////////////////////////////////////
{050408
   加入了热点帖 打开程序时自动打开的项目 根据用mmzHot文件实现
 050409
   全面修改优化代码和算法
 050516
   重新编写了树的算法读取速度加快了10多倍
 051202
   整体优化，内存泄露修复有大幅度的性能提升 压缩率和读取写入速度都提高了近10倍
}
unit PMain;

interface

uses
  Windows, SysUtils, Messages, Variants, Classes, Controls, Forms, RXShell,
  ExtCtrls, Menus, ImgList, StdCtrls, RxRichEd, ComCtrls, Buttons,
  PFormatDefine, PSelffileClass, RzTabs, RzPanel, RzStatus, RzButton,
  RzBckgnd, RzPrgres, Graphics, RzSplit, Dialogs, RzBHints, ActnList,
  RzLabel, RzEdit,  RzRadChk, Mask, PMyColoctTreeImp;
type
  BuffIG = ^Cardinal;
type
  TPageRecord = class //记录页面信息
    M_RichEdit: TRxRichEdit;
    M_ID: BuffIG;
  end;
  TShowRecContrl = class //显示控制类
  private
    procedure RichEditOnModif(Sender: TObject); //Richedit修改时的事件
    procedure RichEditPopup(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //弹出菜单
    procedure TabSheetExit(Sender: Tobject); //离开事件
    procedure RichEditURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton); //点击url
    procedure NotFound(Sender: TObject; const FindText: string);
  public
    PageContrL: TRzPageControl;
    function CurrRichEdit: Pointer; //返回当前的Richedit
    function NewPage(Iid: BuffIG; Icaption: string; IpopMenu: TPopupMenu):
      boolean; //添加新页
    procedure DeletePage(Iindx: Integer); //删除页
    function IShave(Iid: BuffIG): TRzTabSheet; //如果已经存在就激活
    procedure CloseAllSave; // 判断是否有未保存的窗体
    constructor Create(IPageConTrol: TRzPageControl);
    destructor Destroy; override;
  end;
  TMain = class(TForm)
    ImageList1: TImageList;
    PopupMenuTree: TPopupMenu;
    ButtonmDel: TMenuItem;
    NRename: TMenuItem;
    Naddnote: TMenuItem;
    ImageList2: TImageList;
    PopupMenuTryicon: TPopupMenu;
    N27: TMenuItem;
    N28: TMenuItem;
    RxTrayIcon1: TRxTrayIcon;
    RzSizePanel2: TRzSizePanel;
    RzSizePanel1: TRzSizePanel;
    RzPageControl1: TRzPageControl;
    RzToolbar1: TRzToolbar;
    SpeedButton9: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton1: TSpeedButton;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane2: TRzStatusPane;
    RzStatusPane1: TRzStatusPane;
    RzClockStatus1: TRzClockStatus;
    RzProgressBar1: TRzProgressBar;
    RzMarqueeStatus1: TRzMarqueeStatus;
    RzToolbarButton1: TRzToolbarButton;
    RzToolbarButton2: TRzToolbarButton;
    RzToolbarButton3: TRzToolbarButton;
    RzToolbarButton4: TRzToolbarButton;
    RzToolbarButton5: TRzToolbarButton;
    RzToolbarButton6: TRzToolbarButton;
    PopupFile: TPopupMenu;
    B1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    NDrawNote: TMenuItem;
    NViewClick: TMenuItem;
    NAutoSave: TMenuItem;
    NSaveSet: TMenuItem;
    N31: TMenuItem;
    NTerminate: TMenuItem;
    Popupopt: TPopupMenu;
    B2: TMenuItem;
    I1: TMenuItem;
    U1: TMenuItem;
    S1: TMenuItem;
    C1: TMenuItem;
    L1: TMenuItem;
    R1: TMenuItem;
    PopupEdit: TPopupMenu;
    EditCut11: TMenuItem;
    EditCopy11: TMenuItem;
    EditPaste11: TMenuItem;
    N2: TMenuItem;
    Z1: TMenuItem;
    N5: TMenuItem;
    D1: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    Popupform: TPopupMenu;
    N12: TMenuItem;
    N13: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    PopupMdata: TPopupMenu;
    N20: TMenuItem;
    N29: TMenuItem;
    PopupHelp: TPopupMenu;
    RzSizePanel3: TRzSizePanel;
    RzBackground1: TRzBackground;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    RzPageControl2: TRzPageControl;
    TabSheet1: TRzTabSheet;
    RzSizePanel4: TRzSizePanel;
    ListView1: TListView;
    RzBalloonHints1: TRzBalloonHints;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    N7: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Nabout: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PPageMenu: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N9: TMenuItem;
    RzSizePanel5: TRzSizePanel;
    RzSizePanel6: TRzSizePanel;
    TreeView1: TTreeView;
    RzLabel1: TRzLabel;
    RzCheckBox1: TRzCheckBox;
    RzEdit1: TRzEdit;
    RzStatusPane3: TRzStatusPane;
    RzButton1: TRzButton;
    SpeedButton15: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton26: TSpeedButton;
    N19: TMenuItem;
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure deleteNoteExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RzPageControl1Close(Sender: TObject;
      var AllowClose: Boolean);
    procedure PopupMenuTreePopup(Sender: TObject);
    procedure RzPageControl1TabClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RzToolbarButton3Click(Sender: TObject);
    procedure RzToolbarButton4Click(Sender: TObject);
    procedure RzToolbarButton5Click(Sender: TObject);
    procedure RzToolbarButton6Click(Sender: TObject);
    procedure ExitAppExecute(Sender: TObject);
    procedure NewDBExecute(Sender: TObject);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NoteAddExecute(Sender: TObject);
    procedure savecurExecute(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure SelectBlodExecute(Sender: TObject);
    procedure selectItalicExecute(Sender: TObject);
    procedure SelectUnderlineExecute(Sender: TObject);
    procedure SelectStrikeOuteExecute(Sender: TObject);
    procedure U1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure EditCut11Click(Sender: TObject);
    procedure EditCopy11Click(Sender: TObject);
    procedure EditPaste11Click(Sender: TObject);
    procedure Z1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure NRenameClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure NaboutClick(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure RzEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzToolbarButton2Click(Sender: TObject);
    procedure RzToolbarButton1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure RzSizePanel5HotSpotClick(Sender: TObject);
    procedure RzPageControl2TabClick(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure RzSizePanel3HotSpotClick(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
  private
    Id: Integer;
    Id2: Integer;
    FFileName: string; //保存打开的文件名
    LFmt: RFileContentFmt;
    Lindex: Rindex;
    NoteBuff: TMyColocTTreemap;
    Buff: TmemoryStream;
    Fppointer: pointer; //以上都是缓存
    procedure InitTheTree; //读取目录结构
    procedure SaveCurrContent(ItabSheet: TRzTabSheet); //保存内容
    procedure ReadData; //读取数据
    procedure CauText(CauStr: string); //计算字数
    function GetPassword(Ipos: Integer): string; //取得密码
    procedure SetPsd(Ipos: Integer; IPsd: string); //设置密码
    function EnCryPsd(iPsd: string; Ikind: byte): string; //乱码
    procedure hotykey(var msg: Tmessage); message WM_HOTKEY;
    procedure GetHotFIle(IFileName: string); //获取热点帖子
  public
    MyFile: TSelfFileClass;
    PageCtl: TShowRecContrl;
    TreeCTl: TMyColoctTreeCtl;
    function AppRunOnce: Boolean;
  end;
const
  CShowChange = '已修改';
  CShownoChange = '未修改';
  c_hotFileName = 'mmzHot.ini';
var
  Main: TMain;
implementation

uses Math;

{$R *.dfm}

function TMain.AppRunOnce: Boolean;
var
  HW: Thandle;
  sClassName, sTitle: string;
begin
  sClassName := application.ClassName;
  sTitle := application.Title;
  application.Title := 'MyLoveConnCheckOne'; //更改当前app标题
  HW := findwindow(pchar(sClassName), pchar(sTitle));
  ShowWindow(HW, SW_SHOW);
  (*如果发现已有实例在运行，则关闭自己*)
  application.Title := sTitle; //恢复app标题
  result := Hw <> 0; //存在则返回true,无返回false
  if HW <> 0 then begin
    Result := True;
    application.Terminate;
  end;
end;

function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';
{ TMain }

procedure TMain.InitTheTree;
var
  Ldarray: TStringList;
  LS, LE: Integer;
begin
  TreeView1.Items.Clear;
  TreeCTl := TMyColoctTreeCtl.Create(TreeView1);
  LS := GetTickCount;
  Ldarray := TStringList.Create;
  MyFile.GetItemsDarray(Ldarray);
  Ldarray := TreeCTl.CompostitList(Ldarray);
  //此处的Ldarray将会由 TreeCTl来释放
  TreeCTl.CreateTree(Ldarray);
  LE := GetTickCount;
  TabSheet1.Caption := format('读入%d项，耗时%d豪秒', [TreeView1.Items.Count, LE - LS]);
end;

procedure TMain.SaveCurrContent(ItabSheet: TRzTabSheet);
var
  Tep: Cardinal;
begin
  RzProgressBar1.Percent := 10;
  Lindex := MyFile.GetIndex(TpageRecord(ItabSheet.Data).M_ID^);
  //获取对应的索引
  LFmt := MyFile.GetFmt;
  Buff.SetSize(0);
  TpageRecord(ItabSheet.Data).M_RichEdit.Lines.SaveToStream(Buff);
  RzProgressBar1.Percent := 70;
  Tep := MyFile.UpdateItem(Lindex.MselfidxPos, LFmt, buff);
  TMyColocTTreemap(TreeCTl.GetNoteWithID(Lindex.MselfidxPos).Data).MidxPos := Tep;
  RzStatusPane1.Caption := CShownoChange; //状态改为未修改
  RzProgressBar1.Percent := 90;
  TRxRichEdit(TpageRecord(ItabSheet.Data).M_RichEdit).Modified := False;
  {清除查询出来的列表 因为保存后位置可能变化了而列表记录的没跟着变}
  ListView1.Clear;
  RzProgressBar1.Percent := 0;
end;

procedure TMain.TreeView1Edited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  Tep: pointer;
begin
  Lindex := MyFile.GetIndex(TMyColocTTreemap(Node.Data).MIdxPos);
  LFmt := MyFile.GetFmt;
  LFmt.MCaption := S;
  Buff.SetSize(0);
  MyFile.UpdateItem(TMyColocTTreemap(Node.Data).MIdxPos, LFmt, buff);
  tep := PageCtl.IShave(@TMyColocTTreemap(Node.Data).MIdxPos);
  TRzTabSheet(Tep).Caption := s;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  if AppRunOnce then exit;
  buff := TMemoryStream.Create;
  MyFile := TSelfFileClass.Create(cstFilename + CstExt);
  FFileName := MyFile.FileName;
  PageCtl := TShowRecContrl.Create(RzPageControl1);
  id := GlobalAddAtom('hotkey');
  RegisterHotKey(handle, id, mod_control, 81);
  id2 := GlobalAddAtom('hotkey2');
  RegisterHotKey(handle, id2, mod_control, 87);
  InitTheTree; //窗体创建之后读取树
  //读入热点帖
  GetHotFIle(C_hotFIleName);
end;

procedure TMain.TreeView1Click(Sender: TObject);
begin
  if NDrawNote.Checked then TreeView1.Refresh; //如果要拖放接点那么就刷新
  if NViewClick.Checked then
    if TreeView1.Selected <> nil then begin
      ReadData; //如果是单击浏览就读取数据
//      Gob_Debug.AddLogShower(Format('Id:%s,Pid:%s', [TMyColocTTreemap(TreeView1.Selected.data).Id, TMyColocTTreemap(TreeView1.Selected.data).parentid]));
    end;
end;

procedure TMain.ReadData;
begin
  if TreeView1.Selected.ImageIndex = CimgIdxDir then exit; //如果是文件夹则没有读取动作
  if PageCtl.NewPage(@(TMyColocTTreemap(TreeView1.Selected.data).MIdxPos),
    TreeView1.Selected.Text, Popupopt) then Exit; //添加一个新页面
  RzProgressBar1.Percent := 20;
  Lindex := MyFile.GetIndex(TMyColocTTreemap(TreeView1.Selected.data).MIdxPos);
  LFmt := MyFile.GetFmt;
  buff.SetSize(Lindex.MContentlen);
  RzProgressBar1.Percent := 40;
  MyFile.GetContent(buff);
  RzProgressBar1.Percent := 90;
  Buff.Position := 0;
  if Buff.Size > 0 then //如果有数据就读入
    TRxRichEdit(TpageRecord(PageCtl.PageContrL.ActivePage.Data).M_Richedit).Lines.LoadFromStream(Buff);
  TRxRichEdit(TpageRecord(PageCtl.PageContrL.ActivePage.Data).M_Richedit).Modified := False;
  RzStatusPane1.Caption := CShownoChange;
  RzProgressBar1.Percent := 0;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  RxTrayIcon1.Active := False;
end;

procedure TMain.TreeView1DblClick(Sender: TObject);
begin
  if TreeView1.Selected <> nil then ReadData;
end;

procedure TMain.TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  H: THitTests;
begin
  if NDrawNote.Checked then TreeView1.BeginDrag(False);
  //--------------------------------------------------------------------允许不选择
  H := TreeView1.GetHitTestInfoAt(x, y);
  if htnowhere in H then TreeView1.ClearSelection(false);
  if TreeView1.Selected <> nil then begin
    RzStatusPane2.Caption := TreeView1.Selected.Text + '被选中';
    RzStatusPane1.Caption := CShownoChange;
  end
  else
    RzStatusPane2.Caption := '未选中任何目标';
end;

procedure TMain.deleteNoteExecute(Sender: TObject);
var
  Tep: pointer;
begin
  if TreeView1.Selected <> nil then
    if TreeView1.Selected.HasChildren then exit;
  if Application.MessageBox('确定要删除此项吗？', '选择', MB_ICONQUESTION +
    MB_YESNO) = idYes then begin
    MyFile.DeleteItem(TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos);
    Tep :=
      PageCtl.IShave(@TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos);
    if Tep <> nil then //如果是当前正在打开的页面就清除
      PageCtl.DeletePage(TRzTabSheet(tep).TabIndex);
    TMyColocTTreemap(TreeView1.Selected.Data).Free;
    TreeView1.Items.Delete(TreeView1.Selected);
  end;
end;

procedure TMain.SelectStrikeOuteExecute(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if fsBold in TRxRichEdit(Fppointer).SelAttributes.Style then
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style - [fsStrikeOut]
  else
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style + [fsStrikeOut];
end;

function TMain.GetPassword(Ipos: Integer): string;
begin
  Lindex := MyFile.GetIndex(Ipos);
  LFmt := MyFile.GetFmt;
  Result := LFmt.MKindStr;
end;

function TMain.EnCryPsd(iPsd: string; Ikind: byte): string;
begin
  Result := iPsd;
end;

procedure TMain.SetPsd(Ipos: Integer; IPsd: string);
begin
  Lindex := MyFile.GetIndex(Ipos);
  LFmt := MyFile.GetFmt;
  Buff.SetSize(0);
  LFmt.MKindStr := EnCryPsd(IPsd, 1);
  MyFile.UpdateItem(Ipos, LFmt, buff);
  LFmt.MKindStr := '';
end;

procedure TMain.hotykey(var msg: tmessage);
begin
  if (msg.LParamLo = MOD_CONTROL) and (msg.LParamHi = 81) then begin
    Self.WindowState := wsMinimized;
    hide;
  end;
  if (msg.LParamLo = MOD_CONTROL) and (msg.LParamHi = 87) then begin
    Self.WindowState := wsMaximized;
    Show;
  end;
end;

function GetNoteWithText(ITree: TTreeView; IStr: string): TTreeNode;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ITree.Items.Count - 1 do
    if ITree.Items[i].Text = Trim(IStr) then begin
      Result := ITree.Items[i];
      Exit;
    end;
end;

procedure TMain.GetHotFIle(IFileName: string);
var
  I: Integer;
  Ltep: TTreeNode;
  LList: TStringList;
begin
  LList := TStringList.Create;
  with LList do begin
    try
      try
        LoadFromFile(C_hotFIleName);
        for I := 0 to Count - 1 do begin // Iterate
          if Strings[i] <> '' then begin
            Ltep := GetNoteWithText(TreeView1, Strings[i]);
            if Ltep <> nil then begin
              Ltep.Selected := True;
              ReadData;
            end;
          end;
        end; // for
      except
      end;
    finally
      Free;
    end;
  end; // with
end;

{ TShowRecContrl }

constructor TShowRecContrl.Create(IPageConTrol: TRzPageControl);
begin
  PageContrl := IPageConTrol;
end;

function TShowRecContrl.CurrRichEdit: Pointer;
begin
  Result := nil;
  if PageContrL.ActivePageIndex = -1 then exit;
  Result := TpageRecord(PageContrL.Pages[PageContrL.ActivePageIndex].Data).M_RichEdit;
end;

procedure TShowRecContrl.DeletePage(Iindx: Integer);
var
  Tep: pointer;
begin
  Tep := Pointer(PageContrL.Pages[Iindx]);
  if TRzTabSheet(tep).Data <> nil then begin //如果有数据则顺序释放
    if TRxRichEdit(TpageRecord(PageContrL.Pages[Iindx].Data).M_RichEdit).Modified
      then Main.SaveCurrContent(TRzTabSheet(tep));
    TpageRecord(PageContrL.Pages[Iindx].Data).M_RichEdit.free;
    TPageRecord(PageContrL.Pages[Iindx].Data).Free;
    PageContrL.Pages[Iindx].Free;
    PageContrL.SelectNextPage(True);
  end;
end;

destructor TShowRecContrl.Destroy;
var
  I, Tot: Integer;
begin
  Tot := PageContrL.PageCount - 1; //释放所有的页面
  for I := tot downto 0 do
    DeletePage(PageContrL.Pages[i].PageIndex);
  inherited;
end;

procedure TShowRecContrl.CloseAllSave;
var
  I, n: Integer;
begin
  n := PageContrL.PageCount;
  for I := n - 1 downto 0 do
    DeletePage(i);
end;

function TShowRecContrl.IShave(Iid: BuffIG): TRzTabSheet;
//判断此页面是否已经打开
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PageContrL.PageCount - 1 do begin // Iterate
    if PageContrL.Pages[i].Data = nil then Continue;
    if Iid = TpageRecord(PageContrL.Pages[i].Data).M_ID then begin
      Result := PageContrL.Pages[i];
      exit;
    end;
  end; // for
end;

function TShowRecContrl.NewPage(Iid: BuffIG; Icaption: string; IpopMenu:
  TPopupMenu): boolean;
var
  LPage: TRzTabSheet;
  LRichEdit: TRxRichEdit;
  LPageRd: TpageRecord;
  TepPoint: pointer;
begin
  Result := False;
  if PageContrL.PageCount > 0 then begin
    TepPoint := IShave(Iid); //如果已经创建过此页面就激活
    if TepPoint <> nil then begin
      PageContrL.ActivePage := TRzTabSheet(TepPoint);
      Result := True;
      exit;
    end;
  end;
  LPage := TRzTabSheet.Create(PageContrL); //创建表单
  LPage.PageControl := PageContrL;
  LPage.Caption := Icaption;
  LPage.OnExit := TabSheetExit;
  LRichEdit := TRxRichEdit.Create(LPage); //创建Richedit
  LRichEdit.Parent := LPage;
  LRichEdit.Align := alClient;
  LRichEdit.OnURLClick := RichEditURLClick;
  LRichEdit.BorderStyle := bsNone;
  LRichEdit.OnMouseDown := RichEditPopup;
  LRichEdit.OnChange := RichEditOnModif;
  LRichEdit.OnTextNotFound := NotFound;
  LRichEdit.Modified := False;
  LPageRd := TPageRecord.Create; //创建记录
  LPageRd.M_RichEdit := LRichEdit;
  LPageRd.M_ID := iid;
  LPage.Data := LPageRd; //记录挂钩
  PageContrL.ActivePage := LPage; //设置当前页
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  PageCtl.Free;
  MyFile.Free;
  if assigned(TreeCTl) then
    TreeCTl.Free;
  UnRegisterHotKey(handle, id);
  UnRegisterHotKey(handle, id2);
  GlobalDeleteAtom(Id);
  GlobalDeleteAtom(Id2);
end;

procedure TMain.RzPageControl1Close(Sender: TObject;
  var AllowClose: Boolean);
begin
  PageCtl.DeletePage(PageCtl.PageContrL.ActivePageIndex);
end;

procedure TShowRecContrl.RichEditOnModif(Sender: TObject);
begin
  if Main.SpeedButton24.Down then begin
    TRxRichEdit(Sender).ReadOnly := True;
    TRxRichEdit(Sender).Modified := False;
  end
  else TRxRichEdit(Sender).ReadOnly := False;
  if TRxRichEdit(Sender).Modified then Main.RzStatusPane1.Caption := CShowChange;
end;

procedure TMain.PopupMenuTreePopup(Sender: TObject);
begin
  if TreeView1.Selected <> nil then begin
    if TreeView1.Selected.HasChildren then begin
      buttonmDel.Caption := '请先删除子文件';
      ButtonmDel.Enabled := False;
    end
    else begin
      buttonmDel.Caption := '删除节点';
      ButtonmDel.Enabled := True;
    end;
    NRename.Enabled := True;
  end
  else begin
    ButtonmDel.Enabled := False;
    NRename.Enabled := False;
  end;
end;

procedure TShowRecContrl.RichEditPopup(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
begin
  if Button <> mbRight then Exit;
  PT.X := X;
  PT.Y := Y;
  PT := TRxRichEdit(CurrRichEdit).ClientToScreen(PT);
  Main.Popupopt.Popup(PT.X, PT.Y);
end;

procedure TShowRecContrl.TabSheetExit(Sender: Tobject);
begin
  if TRxRichEdit(CurrRichEdit).Modified then
    Main.SaveCurrContent(PageContrL.ActivePage);
end;

procedure TMain.RzPageControl1TabClick(Sender: TObject);
var
  TEp: pointer;
begin
  Tep := TreeCTl.GetNoteWithID(TpageRecord(PageCtl.PageContrL.ActivePage.data).M_ID^);
  TTreeNode(Tep).Selected := True;
  RzStatusPane2.Caption := TTreeNode(Tep).Text + '被选中';
end;

procedure TMain.SpeedButton1Click(Sender: TObject);
begin
  RzSizePanel2.HotSpotIgnoreMargins := not RzSizePanel2.HotSpotIgnoreMargins;
end;

procedure TMain.RzToolbarButton3Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton3.Left;
  Tep1.y := RzToolbarButton3.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  Popupopt.Popup(tep.X, tep.Y);
end;

procedure TMain.RzToolbarButton4Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton4.Left;
  Tep1.y := RzToolbarButton4.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  Popupform.Popup(tep.X, tep.Y);
end;

procedure TMain.RzToolbarButton5Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton5.Left;
  Tep1.y := RzToolbarButton5.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  PopupMdata.Popup(tep.X, tep.Y);
end;

procedure TMain.RzToolbarButton6Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton6.Left;
  Tep1.y := RzToolbarButton6.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  PopupHelp.Popup(tep.X, tep.Y);
end;

procedure TMain.ExitAppExecute(Sender: TObject);
begin
  Main.Close;
end;

procedure TMain.NewDBExecute(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TMain.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TargetNode, SourceNode: TTreeNode;
begin
  TargetNode := TreeView1.GetNodeAt(X, Y);
  if TargetNode = nil then Exit;
  SourceNode := TreeView1.Selected;
  if TargetNode.ImageIndex <> CimgIdxDir then
    if MessageDlg('您选择的不是一个文件夹，如果继续会把您文件里的内容覆盖掉 继续吗？', mtConfirmation,
      [mbYes, mbNo], 0) <> mryes then exit;
  SourceNode.MoveTo(TargetNode, naAddChildFirst);
  TargetNode.Expand(False);
  Lindex := MyFile.GetIndex(TMyColocTTreemap(SourceNode.Data).MIdxPos);
  LFmt := MyFile.GetFmt;
  LFmt.MParentId := Strtoint(TMyColocTTreemap(TargetNode.Data).Id);
  TMyColocTTreemap(SourceNode.Data).Mfmt.MParentId := LFmt.MParentId;
  Buff.Size := 0;
  MyFile.UpdateItem(Lindex.MselfidxPos, LFmt, Buff);
end;

procedure TMain.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  TargetNode, SourceNode: TTreeNode;
begin
  TargetNode := TreeView1.GetNodeAt(X, Y);
  if (Source = Sender) and (TargetNode <> nil) then begin
    Accept := True;
    SourceNode := TreeView1.Selected;
    while (TargetNode.Parent <> nil) and
      (TargetNode <> SourceNode) do
      TargetNode := TargetNode.Parent;
    if TargetNode = SourceNode then
      Accept := False;
  end
  else
    Accept := False;
end;

procedure TMain.NoteAddExecute(Sender: TObject);
var
  T: TTreeNode;
begin
  if TreeView1.Selected <> nil then begin
    //----------------------------------------------------------------创建新文件
    if TreeView1.Selected.ImageIndex = CimgIdxFile then
      if
        MessageDlg('您所选的父节点里有内容，如果添加它的子节点将会清除掉确认要将其改为目录吗？',
        mtWarning, [mbyes, mbno], 0) <> mryes then Exit;
    T := TreeView1.Items.AddChild(TreeView1.Selected, '新文件');
    NoteBuff := TMyColocTTreemap.Create;
    T.Data := NoteBuff;
    T.ImageIndex := CimgIdxFile;
    if TreeView1.Selected.ImageIndex <> CimgIdxDir then begin
      //更改被添加的节点为文件夹
      TreeView1.Selected.ImageIndex := CimgIdxDir;
      Lindex := MyFile.GetIndex(TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos);
      LFmt := MyFile.GetFmt;
      LFmt.Mkind := CimgIdxDir;
      Buff.SetSize(0);
      MyFile.UpdateItem(TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos, LFmt, buff);
    end;
  end
  else begin
    //-----------------------------------------------------------------创建文件
    T := TreeView1.Items.Add(nil, '新文件');
    NoteBuff := TMyColocTTreemap.Create;
    T.Data := NoteBuff;
    T.ImageIndex := CimgIdxFile;
    T.EditText;
  end;
  LFmt.Mkind := T.ImageIndex;
  if T.Parent <> nil then
    LFmt.MParentId := Strtoint(TMyColocTTreemap(T.Parent.Data).Id)
  else
    LFmt.MParentId := CstNotExits;
  LFmt.MCaption := T.Text;
  LFmt.MKindStr := ''; //新节点是没有密码的
  Buff.SetSize(0);
  TMyColocTTreemap(T.Data).Id := InttoStr(MyFile.AddItems(LFmt, buff));
  TMyColocTTreemap(T.Data).Mfmt.MParentId := LFmt.MParentId;
  TMyColocTTreemap(T.Data).MIdxPos := MyFile.IndexHead.LastGoodIdxPos;
  if t.ImageIndex = CimgIdxFile then
    PageCtl.NewPage(@TMyColocTTreemap(t.Data).MIdxPos, t.Text, Popupopt);
  T.Selected := True;
  t.EditText;
end;

procedure TMain.savecurExecute(Sender: TObject);
var
  Tep: pointer;
begin
  Tep := PageCtl.PageContrL.ActivePage;
  if tep <> nil then SaveCurrContent(TRzTabSheet(Tep));
end;

procedure TMain.N20Click(Sender: TObject);
var
  Parth: string;
  Tep: string;
  LFalg: boolean;
begin
  if Application.MessageBox(Pchar('保存的数据文件位于安装目录的\BackUpDir下,保存后您可以把把它发给别人让大家一起来分享你的收藏，也可以在必要的情况下恢复数据,确认要保存吗？'),
    '选择', MB_ICONQUESTION + MB_YESNO) <> idYes then exit;
  Parth := ExtractFilePath(Application.ExeName);
  CreateDir(Parth + 'BackUpDir');
  Tep := FormatDateTime('yyyymmddss', now);
  PageCtl.Free;
  RzProgressBar1.Percent := 10;
  MyFile.Free;
  RzProgressBar1.Percent := 40;
  Tep := Parth + 'BackUpDir\' + Tep + 'bak' + CstExt;
  LFalg := CopyFile(Pchar(Parth + FFileName), Pchar(Tep), True);
//  if not LFalg then ShowMessage('失败')
//  else begin
//    try
//      RzProgressBar1.Percent := 60;
//      winexec(pchar('C:\Program Files\WinRAR\WinRAR.exe m ' + Copy(Tep, 1,
//        length(tep) - 4) + ' ' + Tep), sw_show);
//      Showmessage('保存成功 正在压缩数据压缩率高达10多倍哦 若不想压缩请点击取消，路径为：'
//        + Tep);
//    except
//      Showmessage('保存成功，路径为：' + Tep + 'bak');
//    end;
//  end;
  Showmessage('保存成功，路径为：' + Tep);
  RzProgressBar1.Percent := 70;
  MyFile := TSelfFileClass.Create(FFileName);
  InitTheTree;
  RzProgressBar1.Percent := 95;
  PageCtl := TShowRecContrl.Create(RzPageControl1);
  RzProgressBar1.Percent := 0;
end;

procedure TMain.SelectBlodExecute(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if fsBold in TRxRichEdit(Fppointer).SelAttributes.Style then
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style - [fsBold]
  else
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style + [fsBold];
end;

procedure TMain.selectItalicExecute(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if fsItalic in TRxRichEdit(Fppointer).SelAttributes.Style then
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style - [fsItalic]
  else
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style + [fsItalic];
end;

procedure TMain.SelectUnderlineExecute(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if fsUnderline in TRxRichEdit(Fppointer).SelAttributes.Style then
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style - [fsUnderline]
  else
    TRxRichEdit(Fppointer).SelAttributes.Style :=
      TRxRichEdit(Fppointer).SelAttributes.Style + [fsUnderline];
end;

procedure TMain.U1Click(Sender: TObject);
begin
  SelectUnderlineExecute(Sender);
end;

procedure TMain.S1Click(Sender: TObject);
begin
  SelectStrikeOuteExecute(Sender);
end;

procedure TMain.SpeedButton13Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).Paragraph.Alignment := paCenter;
end;

procedure TMain.SpeedButton14Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).Paragraph.Alignment := paRightJustify;
end;

procedure TMain.SpeedButton12Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).Paragraph.Alignment := paLeftJustify;
end;

procedure TMain.SpeedButton25Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).InsertObjectDialog;
end;

procedure TMain.SpeedButton5Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).PasteFromClipboard;
  TRxRichEdit(Fppointer).SetFocus;
end;

procedure TMain.SpeedButton4Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).CopyToClipboard;
end;

procedure TMain.SpeedButton3Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).CutToClipboard;
end;

procedure TMain.SpeedButton6Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).Undo;
end;

procedure TMain.SpeedButton7Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).ClearSelection;
end;

procedure TMain.SpeedButton20Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).SelAttributes.Size :=
    TRxRichEdit(Fppointer).SelAttributes.Size + 1;
end;

procedure TMain.SpeedButton21Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).SelAttributes.Size :=
    TRxRichEdit(Fppointer).SelAttributes.Size - 1;
end;

procedure TMain.SpeedButton22Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if FontDialog1.Execute then
    TRxRichEdit(Fppointer).SelAttributes.Name := FontDialog1.Font.Name;
end;

procedure TMain.SpeedButton18Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if ColorDialog1.Execute then
    TRxRichEdit(Fppointer).SelAttributes.Color := ColorDialog1.Color;
end;

procedure TMain.SpeedButton23Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if ColorDialog1.Execute then
    TRxRichEdit(Fppointer).SelAttributes.BackColor := ColorDialog1.Color;
end;

procedure Tmain.CauText(CauStr: string);
var
  i, n: integer;
  Instr, s, t: string;
  TP: WideString;
begin
  i := Length(CauStr);
  S := inttostr(i);
  Tp := CauStr;
  n := length(tp);
  T := inttostr(n);
  Instr := '共有:' + #13 + s + '字节' + #13 + T + '个字';
  MessageBox(Handle, Pchar(instr), '字数计算', MB_ICONASTERISK);
end;

procedure TMain.SpeedButton17Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if TRxRichEdit(Fppointer).SelLength > 0 then
    CauText(TRxRichEdit(Fppointer).SelText)
  else
    CauText(TRxRichEdit(Fppointer).Text);
end;

procedure TMain.SpeedButton10Click(Sender: TObject);
begin
  SelectStrikeOuteExecute(Sender);
end;

procedure TMain.SpeedButton11Click(Sender: TObject);
begin
  SelectUnderlineExecute(Sender);
end;

procedure TMain.SpeedButton9Click(Sender: TObject);
begin
  selectItalicExecute(Sender);
end;

procedure TMain.EditCut11Click(Sender: TObject);
begin
  SpeedButton3.Click;
end;

procedure TMain.EditCopy11Click(Sender: TObject);
begin
  SpeedButton4.Click;
end;

procedure TMain.EditPaste11Click(Sender: TObject);
begin
  SpeedButton5.Click;
end;

procedure TMain.Z1Click(Sender: TObject);
begin
  SpeedButton6.Click;
end;

procedure TMain.D1Click(Sender: TObject);
begin
  SpeedButton7.Click;
end;

procedure TMain.N8Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  N8.Checked := not N8.Checked;
  TRxRichEdit(Fppointer).WordWrap := N8.Checked;
end;

procedure TMain.C1Click(Sender: TObject);
begin
  SpeedButton13.Click;
end;

procedure TMain.L1Click(Sender: TObject);
begin
  SpeedButton12.Click;
end;

procedure TMain.R1Click(Sender: TObject);
begin
  SpeedButton14.Click;
end;

procedure TMain.NRenameClick(Sender: TObject);
begin
  TreeView1.Selected.EditText;
end;

procedure TMain.N10Click(Sender: TObject);
begin
  SpeedButton25.Click;
end;

procedure TMain.N11Click(Sender: TObject);
begin
  SpeedButton17.Click;
end;

procedure TMain.SpeedButton16Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).Print('打印');
end;

procedure TMain.SaveAs1Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  SaveDialog1.FileName := TreeView1.Selected.Text;
  if SaveDialog1.Execute then
    TRxRichEdit(Fppointer).Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TMain.Open1Click(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TMain.SpeedButton2Click(Sender: TObject);
begin
  SpeedButton1.Click;
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  if OpenDialog1.Execute then begin
    if OpenDialog1.FileName = '' then exit;
    TRxRichEdit(Fppointer).Clear;
    TRxRichEdit(Fppointer).Lines.LoadFromFile(OpenDialog1.FileName);
    PageCtl.PageContrL.ActivePage.Caption :=
      Copy(ExtractFileName(OpenDialog1.FileName), 1,
      Length(ExtractFileName(OpenDialog1.FileName)) - 4);
    with TreeCTl.GetNoteWithID(TpageRecord(PageCtl.PageContrL.ActivePage.Data).M_ID^) do begin
      Text := PageCtl.PageContrL.ActivePage.Caption;
      Lindex := MyFile.GetIndex(TMyColocTTreemap(Data).MIdxPos);
      LFmt := MyFile.GetFmt;
      LFmt.MCaption := Text;
      Buff.SetSize(0);
      MyFile.UpdateItem(TMyColocTTreemap(Data).MIdxPos, LFmt, buff);
    end;
    TRxRichEdit(Fppointer).SetFocus;
  end;
end;

procedure TMain.N27Click(Sender: TObject);
begin
  Self.WindowState := wsMaximized;
  SHow;
end;

procedure TMain.N28Click(Sender: TObject);
begin
  CLose;
end;

procedure TMain.N25Click(Sender: TObject);
begin
  Self.WindowState := wsMinimized;
  Hide;
end;

procedure TMain.FormHide(Sender: TObject);
begin
  RxTrayIcon1.Active := True;
end;

procedure TMain.N29Click(Sender: TObject);
begin
  PageCtl.Free;
  ListView1.Clear;
  RzProgressBar1.Percent := 10;
  MyFile.OptimizeDataBase;
  RzProgressBar1.Percent := 80;
 // MyFile.Free;
  MyFile := TSelfFileClass.Create(FFileName);
  TreeCTl.Free;
  InitTheTree;
  RzProgressBar1.Percent := 95;
  PageCtl := TShowRecContrl.Create(RzPageControl1);
  RzProgressBar1.Percent := 0;
end;

procedure TMain.NaboutClick(Sender: TObject);
begin
  Application.MessageBox(
    '软件名称: 收集小软3.0' + #13 +
    '作者:马敏钊 DFW_ID:mmzmagic QQ:22900104' + #13 +
    '第3方组件: Raize3.0 和 RxRichEdit' + #13 +
    '介绍：能让你学习效率提高的多的东东，自定义数据库的强大运用' + #13 +
    '功能 收集你所喜欢的一切，最大支持4G的内容 ' + #13 +
    '     一切文字处理的功能，对象图形的插入。' + #13 +
    '     飞快的读写速度，超高压缩率，占用少量的资源^_^' + #13
    , '关于');
end;

procedure TMain.RzButton1Click(Sender: TObject);
var
  I, x: Integer;
  LRichEdit: TRxRichEdit;
begin
  if RzCheckBox1.Checked then begin
    LRichEdit := TRxRichEdit.Create(nil);
    LRichEdit.Top := RzPageControl1.Height;
    LRichEdit.Parent := RzPageControl1;
    LRichEdit.Visible := False;
    if ListView1.Items.Count > 0 then ListView1.Clear;
    x := TreeView1.Items.Count - 1;
    for I := 0 to x do begin // Iterate
      if TreeView1.Items[i].ImageIndex = CimgIdxDir then Continue;
      Lindex := MyFile.GetIndex(TMyColocTTreemap(TreeView1.Items[i].data).MIdxPos);
      LFmt := MyFile.GetFmt;
      if InRange(Lindex.MContentlen, 0, 100) then
        Continue;
      buff.SetSize(Lindex.MContentlen);
      MyFile.GetContent(buff);
      Buff.Position := 0;
      if Buff.Size > 0 then //如果有数据就读入
        LRichEdit.Lines.LoadFromStream(Buff);
      if Pos(Uppercase(Trim(RzEdit1.Text)), uppercase(LRichEdit.Text)) > 0 then begin
        with ListView1.Items.Add do begin
          ImageIndex := TreeView1.Items[i].ImageIndex;
          Caption := TreeView1.Items[i].Text;
          Data := TreeView1.Items[i].Data;
        end;
      end;
      RzProgressBar1.Percent := (i * 100) div x;
    end; // for
    RzProgressBar1.Percent := 0;
    RzStatusPane3.Caption := '共找到' + inttostr(ListView1.Items.Count) +
      '项符合要求';
    RzSizePanel4.RestoreHotSpot;
    LRichEdit.Free;
  end
  else begin
    RzProgressBar1.Percent := 0;
    if ListView1.Items.Count > 0 then ListView1.Clear;
    x := TreeView1.Items.Count - 1;
    for I := 0 to x do begin // Iterate
      if Pos(Uppercase(RzEdit1.Text), Uppercase(TreeView1.Items[i].Text)) > 0
        then begin
        with ListView1.Items.Add do begin
          ImageIndex := TreeView1.Items[i].ImageIndex;
          Caption := TreeView1.Items[i].Text;
          Data := TreeView1.Items[i].Data;
        end;
        RzProgressBar1.Percent := (i * 100) div x;
      end;
    end; // for
    RzProgressBar1.Percent := 0;
    RzStatusPane3.Caption := '共找到' + inttostr(ListView1.Items.Count) +
      '项符合要求';
    RzSizePanel4.RestoreHotSpot;
  end;
end;

procedure TMain.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if TreeView1.Items.Count <= 0 then exit;
  RzPageControl2.ActivePageIndex := 0;
  Fppointer := TreeCTl.GetNoteWithID(TMyColocTTreemap(Item.Data).MIdxPos);
  TTreeNode(Fppointer).Expanded := True;
  TTreeNode(Fppointer).Selected := True;
end;

procedure TMain.RzEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then RzButton1.Click;
end;

procedure TMain.RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.WindowState := wsMaximized;
  SHow;
end;

procedure TMain.N3Click(Sender: TObject);
begin
  if PageCtl.PageContrL.PageCount > 0 then
    PageCtl.DeletePage(PageCtl.PageContrL.ActivePageIndex);
end;

procedure TMain.N4Click(Sender: TObject);
begin
  if PageCtl.PageContrL.PageCount > 0 then PageCtl.CloseAllSave;
end;

procedure TMain.N14Click(Sender: TObject);
begin
  if PageCtl.PageContrL.ActivePageIndex > 0 then
    PageCtl.PageContrL.ActivePageIndex := PageCtl.PageContrL.ActivePageIndex -
      1;
end;

procedure TMain.N15Click(Sender: TObject);
begin
  if PageCtl.PageContrL.ActivePageIndex < PageCtl.PageContrL.PageCount - 1 then
    PageCtl.PageContrL.ActivePageIndex := PageCtl.PageContrL.ActivePageIndex +
      1;
end;

procedure TMain.N17Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).FindDialog(TRxRichEdit(Fppointer).SelText).Execute;
end;

procedure TMain.N18Click(Sender: TObject);
begin
  Fppointer := PageCtl.CurrRichEdit;
  if Fppointer = nil then Exit;
  TRxRichEdit(Fppointer).ReplaceDialog(TRxRichEdit(Fppointer).SelText,
    '').Execute;
end;

procedure TMain.N12Click(Sender: TObject);
begin
  if RzSizePanel2.HotSpotClosed then
    RzSizePanel2.RestoreHotSpot
  else
    RzSizePanel2.CloseHotSpot;
end;

procedure TMain.N13Click(Sender: TObject);
begin
  RzToolbar1.Visible := N13.Checked;
end;

procedure TMain.N22Click(Sender: TObject);
begin
  if RzSizePanel4.HotSpotClosed then
    RzSizePanel4.RestoreHotSpot
  else
    RzSizePanel4.CloseHotSpot;
end;

procedure TMain.N23Click(Sender: TObject);
begin
  RzStatusBar1.Visible := N23.Checked;
end;

procedure TShowRecContrl.RichEditURLClick(Sender: TObject; const URLText:
  string;
  Button: TMouseButton);
begin
  if Button <> mbLeft then Exit;
  shellexecute(Application.Handle, nil, pchar(URLText), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TShowRecContrl.NotFound(Sender: TObject; const FindText: string);
begin
  Application.MessageBox(Pchar('不好意思 搜索完全文也没有找到您要的<' + FindText
    + '>'), '提示');
end;

procedure TMain.N9Click(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then begin
    if (key = ord('f')) or (key = ord('F')) then
      N17.Click
    else if (Key = ord('r')) or (key = ord('R')) then
      N18.Click
    else if (key = Ord('t')) or (Key = ord('T')) then
      N10.Click;
  end;
end;

procedure TMain.RzToolbarButton2Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton2.Left;
  Tep1.y := RzToolbarButton2.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  PopupEdit.Popup(tep.X, tep.Y);
end;

procedure TMain.RzToolbarButton1Click(Sender: TObject);
var
  Tep, tep1: TPoint;
begin
  Tep1.X := RzToolbarButton1.Left;
  Tep1.y := RzToolbarButton1.BoundsRect.Bottom;
  Tep := ClientToScreen(tep1);
  PopupFile.Popup(tep.X, tep.Y);
end;

procedure TMain.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then begin
    RzPageControl2.ActivePageIndex := 0;
    Fppointer := TreeCTl.GetNoteWithID(TMyColocTTreemap(ListView1.Selected.Data).MIdxPos);
    ReadData;
  end;
end;

procedure TMain.RzSizePanel5HotSpotClick(Sender: TObject);
begin
  if RzSizePanel5.HotSpotClosed then begin
    RzStatusPane3.Visible := False;
  end
  else begin
    RzStatusPane3.Visible := True;
  end;
end;

procedure TMain.RzPageControl2TabClick(Sender: TObject);
begin
  TabSheet1.Caption := format('目录树(%d)', [TreeView1.Items.Count]);
end;

procedure TMain.SpeedButton15Click(Sender: TObject);
begin
  GetHotFIle(C_hotFIleName);
end;

procedure TMain.RzSizePanel3HotSpotClick(Sender: TObject);
var
  I: Integer;
  Lstate: boolean;
begin
  if RzSizePanel3.HotSpotClosed then
    Lstate := False
  else Lstate := True;
  for I := 0 to ComponentCount - 1 do begin // Iterate
    if Components[i] is TRzToolbarButton then
      TRzToolbarButton(Components[i]).Visible := Lstate;
  end; // for
end;

procedure TMain.SpeedButton24Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to PageCtl.PageContrL.PageCount - 1 do
    TPageRecord(PageCtl.PageContrL.Pages[i].Data).M_RichEdit.ReadOnly := True;
end;

procedure TMain.SpeedButton26Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to PageCtl.PageContrL.PageCount - 1 do
    TPageRecord(PageCtl.PageContrL.Pages[i].Data).M_RichEdit.ReadOnly := False;
end;

procedure TMain.N19Click(Sender: TObject);
var
  T: TTreeNode;
begin
  if TreeView1.Selected <> nil then begin
    //----------------------------------------------------------------创建新文件
    if TreeView1.Selected.ImageIndex = CimgIdxFile then
      if
        MessageDlg('您所选的父节点里有内容，如果添加它的子节点将会清除掉确认要将其改为目录吗？',
        mtWarning, [mbyes, mbno], 0) <> mryes then Exit;
    T := TreeView1.Items.AddChild(TreeView1.Selected, '新文件夹');
    NoteBuff := TMyColocTTreemap.Create;
    T.Data := NoteBuff;
    T.ImageIndex := CimgIdxDir;
    if TreeView1.Selected.ImageIndex <> CimgIdxDir then begin
      //更改被添加的节点为文件夹
      TreeView1.Selected.ImageIndex := CimgIdxDir;
      Lindex := MyFile.GetIndex(TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos);
      LFmt := MyFile.GetFmt;
      LFmt.Mkind := CimgIdxDir;
      Buff.SetSize(0);
      MyFile.UpdateItem(TMyColocTTreemap(TreeView1.Selected.Data).MIdxPos, LFmt, buff);
    end;
  end
  else begin
    //-----------------------------------------------------------------创建文件
    T := TreeView1.Items.Add(nil, '新文件夹');
    NoteBuff := TMyColocTTreemap.Create;
    T.Data := NoteBuff;
    T.ImageIndex := CimgIdxDir;
  end;
  LFmt.Mkind := T.ImageIndex;
  if T.Parent <> nil then
    LFmt.MParentId := Strtoint(TMyColocTTreemap(T.Parent.Data).Id)
  else
    LFmt.MParentId := CstNotExits;
  LFmt.MCaption := T.Text;
  LFmt.MKindStr := ''; //新节点是没有密码的
  Buff.SetSize(0);
  TMyColocTTreemap(T.Data).Id := InttoStr(MyFile.AddItems(LFmt, buff));
  TMyColocTTreemap(T.Data).Mfmt.MParentId := LFmt.MParentId;
  TMyColocTTreemap(T.Data).MIdxPos := MyFile.IndexHead.LastGoodIdxPos;
  if t.ImageIndex = CimgIdxFile then
    PageCtl.NewPage(@TMyColocTTreemap(t.Data).MIdxPos, t.Text, Popupopt);
  T.Selected := True;
  t.EditText;
end;

end.

