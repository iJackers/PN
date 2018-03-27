///////////////////////////////////////////////////////////////////////////////
//此单元为演示单元                                                          //
//建立日期为2004年8月24日                                                  //
//当前版本号为v1.0                                                        //
//创建人mmzmagic   QQ 22900104   有啥意见一起讨论哈                      //
//////////////////////////////////////////////////////////////////////////
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, pselffileclass, PformatDefine, Dialogs, ExtCtrls, Menus,
  ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    StatusBar1: TStatusBar;
    Button4: TButton;
    PopupMenu1: TPopupMenu;
    ddd1: TMenuItem;
    Button5: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ddd1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    Flist: TList;
  public
    procedure GetDarr;
  end;
type
  RContent = record
    Rkind: byte;
    Rcap: string;
    RTxt: string;
  end;
var
  Form1: TForm1;
  MyFile: TSelfFileClass;
implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do begin
    FileName := '未命名.pws';
    Filter := '(*.pws)';
    if Execute then begin
      if FileName = '' then Exit;
      MyFile := TSelfFileClass.Create(FileName);
    end;
    Free;
  end; // with

  if not (Assigned(MyFile) and MyFile.IsRightFile) then begin
    ShowMessage('加载数据库失败');
    exit;
  end;
  GetDarr;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  LFmt: RecContentFmt;
  ContentBuff: TMemoryStream;
begin
  LFmt.kind := RadioGroup1.ItemIndex;
  LFmt.Captionlen := Edit1.Text;
  ContentBuff := TMemoryStream.Create;
  ContentBuff.SetSize(Memo1.GetTextLen + 1);
  Memo1.GetTextBuf(ContentBuff.Memory, ContentBuff.Size);
  MyFile.AddItems(LFmt, ContentBuff);
  ContentBuff.Free;
  ListBox1.Items.Add(Edit1.Text);
  Flist.Add(Pointer(MyFile.IndexHead.LastGoodIdxPos));
  StatusBar1.Panels[0].Text := '好的索引有:' + inttostr(MyFile.IndexHead.GoodIdxCount) +
    '             ' + '坏的索引有:' + inttostr(MyFile.IndexHead.BadIdxCount);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Flist.Free;
  if Assigned(MyFile) then
    MyFile.Free;
end;

{ TSupperFile }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Flist := Tlist.Create;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  Tepidx: IndexBody;
  TepFmt: RecContentFmt;
  Buff: TMemoryStream;
begin
  if ListBox1.ItemIndex > -1 then begin
    Tepidx := MyFile.GetIndex(Integer(Flist.Items[ListBox1.ItemIndex]));
    with Tepidx do begin
      TepFmt := MyFile.GetFmt;
      Edit1.Text := TepFmt.Captionlen;
      RadioGroup1.ItemIndex := TepFmt.kind;
      Buff := TMemoryStream.Create;
      Buff.SetSize(Tepidx.CurContentLen);
      MyFile.GetContent(Buff);
      Memo1.SetTextBuf(Buff.Memory);
      Buff.Free;
    end; // with
  end;
end;

procedure TForm1.ddd1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex > -1 then begin
    myFile.DeleteItem(integer(Flist.Items[ListBox1.ItemIndex]));
    Flist.Delete(ListBox1.ItemIndex);
    ListBox1.DeleteSelected;
    StatusBar1.Panels[0].Text := '好的索引有:' + inttostr(MyFile.IndexHead.GoodIdxCount) +
      '             ' + '坏的索引有:' + inttostr(MyFile.IndexHead.BadIdxCount);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Lfmt: RecContentFmt;
  ContentBuff: TMemoryStream;
begin
  if ListBox1.ItemIndex > -1 then begin
    Lfmt.kind := RadioGroup1.ItemIndex;
    Lfmt.Captionlen := Edit1.Text;
    ListBox1.Items[ListBox1.ItemIndex] := Lfmt.Captionlen;
    ContentBuff := TMemoryStream.Create;
    ContentBuff.SetSize(Memo1.GetTextLen + 1);
    Memo1.GetTextBuf(ContentBuff.Memory, ContentBuff.Size);
    Flist.Items[ListBox1.ItemIndex] := Pointer(MyFile.UpdateItem(Integer(Flist.items[ListBox1.ItemIndex])
      , Lfmt, ContentBuff));
    ContentBuff.Free;
    StatusBar1.Panels[0].Text := '好的索引有:' + inttostr(MyFile.IndexHead.GoodIdxCount) +
      '             ' + '坏的索引有:' + inttostr(MyFile.IndexHead.BadIdxCount);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Old: string;
begin
  old := MyFile.FileName;
  MyFile.OptimizeDataBase;
  MyFile := TSelfFileClass.Create(Old);
  GetDarr;
end;

procedure TForm1.GetDarr;
var
  I: Integer;
  Darr: DarrayList;
begin
  if MyFile.IndexHead.GoodIdxCount > 0 then begin
    ListBox1.Clear;
    Flist.Clear;
    MyFile.GetItemsDarray(Darr);
    for I := 0 to length(Darr) - 1 do begin // Iterate
      ListBox1.Items.Add(darr[i].DataCaption);
      Flist.Add(Pointer(Darr[i].DataIdxPos));
    end; // for
  end;
  StatusBar1.Panels[0].Text := '好的索引有:' + inttostr(MyFile.IndexHead.GoodIdxCount) +
    '             ' + '坏的索引有:' + inttostr(MyFile.IndexHead.BadIdxCount);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  Tep: Integer;
  Tepidx: IndexBody;
  TepFmt: RecContentFmt;
  Buff: TMemoryStream;
begin
  Tep := MyFile.GetIdxPosWithCpt(InputBox('输入你要查找的标题','',''));
  if tep <> CnstNotExits then begin
    Tepidx := MyFile.GetIndex(tep);
    with Tepidx do begin
      TepFmt := MyFile.GetFmt;
      Edit1.Text := TepFmt.Captionlen;
      RadioGroup1.ItemIndex := TepFmt.kind;
      Buff := TMemoryStream.Create;
      Buff.SetSize(Tepidx.CurContentLen);
      MyFile.GetContent(Buff);
      Memo1.SetTextBuf(Buff.Memory);
      Buff.Free;
    end; // with
  end
  Else ShowMessage('Not Found!');
end;

end.

