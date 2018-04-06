unit DispatchMp3File;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, System.Actions, Vcl.ActnList, UntConst;

const
  pwsHead: string = '#Special Music List';
  pwnHead: string = '#Normal Music List';

type
  TMp3Lstfrm = class(TForm)
    pgcMp3File: TPageControl;
    tsSpecLst: TTabSheet;
    tsNorLst: TTabSheet;
    pnlBtn: TPanel;
    btnOpenMusLst: TBitBtn;
    btnAddMusFld: TBitBtn;
    btnAddMus: TBitBtn;
    btnDeleteMus: TBitBtn;
    btnClearMusLst: TBitBtn;
    btnSaveMusLst: TBitBtn;
    lvSpecLst: TListView;
    lvNorLst: TListView;
    dlgOpenLst: TOpenDialog;
    dlgSaveLst: TSaveDialog;
    actlstMenu: TActionList;
    actOpenLst: TAction;
    actSaveLst: TAction;
    actClearFileList: TAction;
    procedure btnOpenMusLstClick(Sender: TObject);
    procedure actOpenLstExecute(Sender: TObject);
    procedure btnSaveMusLstClick(Sender: TObject);
    procedure actSaveLstExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClearMusLstClick(Sender: TObject);
    procedure actClearFileListExecute(Sender: TObject);
  private
    { Private declarations }
    pwsPath, pwsFlnm: string;
    //pwnPath, pwnFlnm: string;
    function doLvAddMusicLst(sMusicInfo: string; IsPws: Boolean): boolean;
    procedure SaveToPws(sMusic: TStringList; sFileName: string);
    procedure LoadMusLstFile(sFileName: string; isPws: Boolean);
  public
    { Public declarations }
  end;

var
  Mp3Lstfrm: TMp3Lstfrm;

implementation

{$R *.dfm}

procedure TMp3Lstfrm.actClearFileListExecute(Sender: TObject);
begin
  if pgcMp3File.ActivePageIndex = 0 then
  begin
    with lvSpecLst.Items do
    begin
      Clear;
    end;
  end
  else
  begin
    with lvNorLst.Items do
    begin
      clear;
    end;
  end;
end;

procedure TMp3Lstfrm.actOpenLstExecute(Sender: TObject);
var
  FlnmLst, sLines: string;
  IsPws: boolean;
begin
  IsPws := false;
  if pgcMp3File.ActivePage.Name = tsSpecLst.Name then
  begin
    dlgOpenLst.Filter := '播放列表文件|*.pws';
    dlgOpenLst.DefaultExt := '*.pws';
    IsPws := true;
  end;
  if pgcMp3File.ActivePage.Name = tsNorLst.Name then
  begin
    dlgOpenLst.Filter := '播放列表文件|*.pwn';
    dlgOpenLst.DefaultExt := '*.pwn';
    IsPws := false;
  end;

  if DirectoryExists('D:\Music') then
    dlgOpenLst.InitialDir := 'D:\Music'
  else
    dlgOpenLst.InitialDir := ExtractFilePath(ParamStr(0));

  dlgOpenLst.FileName := '';
  if dlgOpenLst.Execute then
  begin
    FlnmLst := dlgOpenLst.FileName;
    if FileExists(FlnmLst) then
    begin
      LoadMusLstFile(FlnmLst, IsPws);
      //LoadMusicArr(lvSpecLst);
    end;
  end;
end;

procedure TMp3Lstfrm.actSaveLstExecute(Sender: TObject);
var
  I: Integer;
  ss: TStringList;
begin
  if pgcMp3File.ActivePage.Name = tsSpecLst.Name then
  begin
    if not Assigned(lvSpecLst.Items.Item[0]) then
    begin
      ShowMessage('列表为空');
      Exit;
    end;

    ss := TStringlist.Create;

    ss.Add(pwsHead);
    dlgSaveLst.DefaultExt := '*.pws';
    dlgSaveLst.Filter := '播放列表文件|*.pws';

    if dlgSaveLst.Execute then
    begin
      for I := 0 to lvSpecLst.Items.Count - 1 do
      begin
        ss.Add(
                     //lvSpecLst.Items.Item[i].Caption +
          '#' + lvSpecLst.Items.Item[I].SubItems[0] + '#' + lvSpecLst.Items.Item[I].SubItems[1] + '#' + LvSpecLst.Items.Item[I].SubItems[2] + '#' + lvSpecLst.Items.Item[I].SubItems[3])
      end;
      SaveToPws(ss, dlgSaveLst.FileName);
    end;
    ss.Free;
  end;

  if pgcMp3File.ActivePage.Name = tsNorLst.Name then
  begin
    if not Assigned(lvNorLst.Items.Item[0]) then
    begin
      ShowMessage('列表为空');
      Exit;
    end;

    ss := TStringlist.Create;

    ss.Add(pwnHead);
    dlgSaveLst.DefaultExt := '*.pwn';
    dlgSaveLst.Filter := '播放列表文件|*.pwn';

    if dlgSaveLst.Execute then
    begin
      for I := 0 to lvNorLst.Items.Count - 1 do
      begin
        ss.Add('#' + lvNorLst.Items.Item[I].SubItems[0] + '#' + lvNorLst.Items.Item[I].SubItems[1] + '#' + lvNorLst.Items.Item[I].SubItems[2])
      end;
      SaveToPws(ss, dlgSaveLst.FileName);
    end;
  end;
end;

procedure TMp3Lstfrm.btnClearMusLstClick(Sender: TObject);
begin
  actClearFileListExecute(Sender);
end;

procedure TMp3Lstfrm.btnOpenMusLstClick(Sender: TObject);
begin
  actOpenLstExecute(Sender);
end;

procedure TMp3Lstfrm.btnSaveMusLstClick(Sender: TObject);
begin
  actSaveLstExecute(Sender);
end;

function TMp3Lstfrm.doLvAddMusicLst(sMusicInfo: string; IsPws: boolean): boolean;
var
  musicItem: TListItem;
  MusicRec: TMusicFileRec;
begin
  try
    begin
      StrToMusRec(sMusicInfo, MusicRec, '#', IsPws);
      if IsPws then
      begin
        musicItem := lvSpecLst.Items.Add;
        musicItem.Caption := IntToStr(MusicRec.iSecNo);
        musicItem.SubItems.Add(MusicRec.PlayTime);
        musicItem.SubItems.Add(MusicRec.PathName + MusicRec.FileName);
        Result := fileExists(MusicRec.PathName + MusicRec.FileName);
        musicItem.SubItems.Add(MusicRec.MusicLen.ToString);
        musicItem.SubItems.Add(BoolToStr(Result, true));
        if Result then
          begin
            SetLength(SpecMusArr, Length(SpecMusArr) + 1);
            SpecMusArr[Length(SpecMusArr)-1] := MusicRec;
          end;
      end
      else
      begin
        musicItem := lvNorLst.Items.Add;
        musicItem.Caption := IntToStr(MusicRec.iSecNo);
        Result := fileExists(MusicRec.PathName + MusicRec.FileName);
        musicItem.SubItems.Add(MusicRec.PathName + MusicRec.FileName);
        musicItem.SubItems.Add(MusicRec.MusicLen.ToString);
        musicItem.SubItems.Add(BoolToStr(Result, True));
        if Result then
          begin
            SetLength(NorMusArr, Length(NorMusArr) + 1);
            NorMusArr[Length(NorMusArr)-1] := MusicRec;
          end;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure TMp3Lstfrm.FormCreate(Sender: TObject);
begin
  LoadMusLstFile('D:\Music\SpecMusic\Spec.pws', True);
  LoadMusLstFile('D:\Music\NormalMusic\Normal.pwn', false);
end;

procedure TMp3Lstfrm.LoadMusLstFile(sFileName: string; isPws: Boolean);
var
  sLines: string;
  FlnmTxt: TextFile;
  i: integer;
begin
  if FileExists(sFileName) then
  begin
    pwsPath := ExtractFilePath(sFileName);
    pwsFlnm := ExtractFileName(sFileName);

    AssignFile(FlnmTxt, sFileName);
    Reset(FlnmTxt);
    readln(FlnmTxt, sLines);
    if ((sLines <> pwshead) and isPws) or ((sLines <> pwnhead) and (not isPws)) then
    begin
      showmessage('不是正常的文件列表，请联系开发人员！');
      Exit;
    end;

    if isPws then
      lvSpecLst.Items.Clear
    else
      lvNorLst.Items.Clear;

    i := 1;
    while not Eof(FlnmTxt) do
    begin
      Readln(FlnmTxt, sLines);
      doLvAddMusicLst(i.ToString + sLines, isPws);
      Inc(i);
    end;
    CloseFile(FlnmTxt);
  end;
  SetMusicArray;
end;

procedure TMp3Lstfrm.SaveToPws(sMusic: TStringlist; sFileName: string);
var
  I: Integer;
  flnmTxt: TextFile;
begin
  AssignFile(flnmTxt, sFileName);
  Rewrite(flnmTxt);

  for I := 0 to sMusic.Count - 1 do
  begin
    Writeln(flnmTxt, sMusic[I]);
  end;
  CloseFile(flnmTxt);
end;


end.

