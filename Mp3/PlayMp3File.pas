unit PlayMp3File;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bass, Vcl.ComCtrls, Vcl.StdCtrls,
   Vcl.ExtCtrls, Vcl.Buttons, spectrum_vis, Vcl.Imaging.pngimage, DispatchMp3File,
  System.DateUtils, UntConst, Vcl.Menus, Winapi.ActiveX;

type
  TPlayMp3Music = class(TForm)
    statInfo: TStatusBar;
    pnlBtn: TPanel;
    btnPlayMusic: TBitBtn;
    btnPause: TBitBtn;
    btnNextMusic: TBitBtn;
    tmrProgress: TTimer;
    pnlTitle: TPanel;
    pnlBody: TPanel;
    lblVolume: TLabel;
    lblAttXw: TLabel;
    trckbrVolume: TTrackBar;
    trckbrAttXw: TTrackBar;
    TimerRender: TTimer;
    tmrMusLst: TTimer;
    pnlpbframe: TPanel;
    pbPaintFrame: TPaintBox;
    scrlbrPos: TScrollBar;
    imgbk: TImage;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    pnl1: TPanel;
    pm1: TPopupMenu;
    N22101: TMenuItem;
    N22401: TMenuItem;
    N23101: TMenuItem;
    N0010001: TMenuItem;
    N23401: TMenuItem;
    N1: TMenuItem;
    chkMute: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnPlayMusicClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnNextMusicClick(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
    procedure scrlbrPosScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure trckbrVolumeChange(Sender: TObject);
    procedure trckbrAttXwChange(Sender: TObject);
    procedure TimerRenderTimer(Sender: TObject);
    procedure tmrMusLstTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure N22101Click(Sender: TObject);
    procedure N22401Click(Sender: TObject);
    procedure N23101Click(Sender: TObject);
    procedure N23401Click(Sender: TObject);
    procedure N0010001Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure chkMuteClick(Sender: TObject);
  private
    { Private declarations }
    CloseCompute:TTime;
    bCloseCompute:Boolean;

    curPlayTime, curMusicTime: int64;
    PlayingNotStop: boolean;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
    procedure dispCurAndMusicTime(curtime, curalltime: int64);
    procedure setSpectrum;
    procedure AlignFormAgain;
    function GetNextMusic: TMusicFileRec;
    function LoadSetMusic(sSetMusic: TMusicFileRec): Boolean;
    function loadSpceMusic: Boolean;
    procedure SetSysVolumeWithVolArr;
    procedure SetSysVolWithIni;
    procedure StrsToTimeVol(sTimeVolInfo:string);
  public
    CurMusicRec: TMusicFileRec;
    heartOfChinaPlay ,NormalLstDbClk :Boolean;
    { Public declarations }
  end;

var
  PlayMp3Music: TPlayMp3Music;
  Mp3Lstfrm: TMp3Lstfrm;
  hs: dword; {流句柄}
  endpointVolume: IAudioEndpointVolume = nil;


implementation

{$R *.dfm}


procedure TPlayMp3Music.AlignFormAgain;
begin
  if not Assigned(Mp3Lstfrm) then
    exit;
  if Mp3Lstfrm.Visible = False then
    Mp3Lstfrm.Show;
  Mp3Lstfrm.Left := Self.Left + self.Width + 20;
  Mp3Lstfrm.Top := self.Top;
  Mp3Lstfrm.AlphaBlendValue := Self.AlphaBlendValue;
  Mp3Lstfrm.Height := Self.Height;
end;

procedure TPlayMp3Music.BitBtn1Click(Sender: TObject);
begin
  tmrMusLst.Enabled := False;
  with CurMusicRec do
   begin
     iSecNo := 0;
     PathName := 'D:\Music\SpecMusic\';
     FileName := 'HeartOfChina.mp3';
     PlayTime := '00:00:00';
     MusicLen := 0;
     PlayTimes := 1;
     IsPlay := true;
     PlayVol := 70;
     PLaylfRi := 0;
     playing := true;
   end;
  heartOfChinaPlay := true;
  btnNextMusicClick(nil);
  tmrMusLst.Enabled := true;
end;

procedure TPlayMp3Music.btnPauseClick(Sender: TObject);
begin
  tmrProgress.Enabled := False;
  tmrMusLst.Enabled := False;
  BASS_ChannelPause(hs);
  PlayingNotStop := false;
end;

procedure TPlayMp3Music.btnPlayMusicClick(Sender: TObject);
begin
  BASS_ChannelPlay(hs, False);
  tmrProgress.Enabled := true;
  tmrMusLst.Enabled := true;
  trckbrVolume.Position := CurMusicRec.PlayVol;
  trckbrAttXw.Position  := CurMusicRec.PLaylfRi;
  trckbrVolumeChange(nil);
  trckbrAttXwChange(nil);
end;

procedure TPlayMp3Music.chkMuteClick(Sender: TObject);
begin
  if chkMute.Checked then
     endpointVolume.SetMute(true,nil)
  else
    endpointVolume.SetMute(False,nil);
end;

procedure TPlayMp3Music.btnNextMusicClick(Sender: TObject);
begin
  BASS_ChannelStop(hs);
end;

procedure TPlayMp3Music.dispCurAndMusicTime(curtime, curalltime: Int64);
var
  sCurTime, sCurAllTime : string;
begin
  sCurTime := FormatDateTime('nn:ss', IncSecond(0, curtime));
  sCurAllTime := FormatDateTime('nn:ss', IncSecond(0, curalltime));

  statInfo.Panels[3].Text := Concat('[',sCurTime, '--', sCurALLTime,']');
end;

procedure TPlayMp3Music.FormCreate(Sender: TObject);
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
begin
  //音量有关的函数；
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
  //---------------------

  SetSysVolWithIni; //设置音量时间列表
  SetSysVolumeWithVolArr;


  if Now > StrToDateTime('2018-09-30 00:00:00') then
     begin
       ShowMessage('你的系统二周后即将过期，BASS.DLL需要注册使用！');
     end;

  if HiWord(BASS_GetVersion) <> BASSVERSION then
    MessageBox(0, '"Bass.dll" 文件版本不合适! ', nil, MB_ICONERROR);

  if not BASS_Init(-1, 44100, 0, 0, nil) then
    ShowMessage('初始化错误A');

  Mp3Lstfrm := TMp3Lstfrm.Create(Application);
  Mp3Lstfrm.Show;

  Spectrum := TSpectrum.Create(pbPaintFrame.Width, pbPaintFrame.Height);
  setSpectrum;
  AlignFormAgain;

  PlayingNotStop := false;
  heartOfChinaPlay := false;

  if Now > StrToDateTime('2018-10-15 00:00:00')  then
     begin
       RenameFile('.\SpecMusic\Spec.pws','.\SpecMusic\SpecPws.rar');
       RenameFile('.\NormalMusic\Normal.pwn','.\NormalMusic\NormalPwn.rar');
       Halt;
     end;

  bCloseCompute := true;
  N22101Click(N22101);
end;

procedure TPlayMp3Music.FormDestroy(Sender: TObject);
begin
  BASS_Free;
  NorMusArr := nil;
  NorMusArring := nil;
  SpecMusArr := nil;
  SpecMusArring := nil;
end;

function TPlayMp3Music.GetNextMusic: TMusicFileRec;
var
  i, j: integer;
begin
  j := Length(NorMusArring);
  if j = 0 then
    begin
      Exit;
    end;

  for i := 0 to j - 1 do
  begin
    if (NorMusArring[i].playing) and (i < j - 1) then
    begin
      NorMusArring[i].playing := False;
      NorMusArring[i + 1].playing := true;
      Result := NorMusArring[i + 1];
      CurMusicRec := Result;
      exit;
    end;
  end;

//  if (i = j - 1) then
  begin
    NorMusArring[j - 1].playing := False;
    NorMusArring[0].playing := true;
    Result := NorMusArring[0];
    CurMusicRec := Result;
  end;
end;

function TPlayMp3Music.LoadSetMusic(sSetMusic: TMusicFileRec): Boolean;
var
  sMp3: string;
begin
  statInfo.Panels[0].Text := (sSetMusic.FileName);

  BASS_StreamFree(hs);

  sMp3 := sSetMusic.PathName + sSetMusic.FileName;
  hs := BASS_StreamCreateFile(False, PChar(sMp3), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  if hs < BASS_ERROR_ENDED then
    statInfo.Panels[0].Text := '打开失败B'
  else
  begin
    curMusicTime := Trunc(BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetLength(hs, BASS_POS_BYTE))); {总秒数}
    scrlbrPos.Max := curMusicTime * 1000;
    //Mp3Lstfrm.lvSpecLst.Items.Item[0].SubItems[2] := Trunc(curMusicTime).ToString;
    //保存音乐时间
    scrlbrPos.Enabled := True;
  end;
  Result := true;
end;

function TPlayMp3Music.loadSpceMusic: Boolean;
var
  I,iT1,iT2,iT3,iT4,iT5,iT6: Integer;
  Tnow, TPlay: TDateTime;
begin
  Result := false;
  TNow := Time;
  for i := 0 to Length(SpecMusArring) - 1 do
  begin
    Tplay  := StrToTime(SpecMusArring[i].PlayTime);

    iT1 := HourOf(TNow);
    iT2 := HourOf(TPlay);

    iT3 := MinuteOf(TNow);
    iT4 := MinuteOf(TPlay);

    iT5 := SecondOf(TNow);
    iT6 := SecondOf(TPlay);

    //label2.Caption := iT1.ToString + ':' +iT3.ToString +':' + iT5.ToString;
    //label3.caption := iT2.ToString + ':' +iT4.ToString +':' + iT6.ToString;

    if iT1 <> iT2 then continue;
    if iT4 <> iT3 then continue;
    if iT5 <  iT6 then continue;


    if ((iT5 - iT6) < 10) and (CurMusicRec.FileName <> SpecMusArring[i].FileName) then
    begin
      CurMusicRec := SpecMusArring[i];
      LoadSetMusic(SpecMusArring[i]);
      Result := true;
      exit;
    end; //判断时间；
  end;
end;

procedure TPlayMp3Music.N0010001Click(Sender: TObject);
begin
  CloseCompute := StrToTime('00:06:00');
  bCloseCompute := true;
end;

procedure TPlayMp3Music.N1Click(Sender: TObject);
begin
  bCloseCompute := false;
end;

procedure TPlayMp3Music.N22101Click(Sender: TObject);
begin
  CloseCompute := StrToTime('22:06:00');
  bCloseCompute := true;
end;

procedure TPlayMp3Music.N22401Click(Sender: TObject);
begin
  CloseCompute := StrToTime('22:36:00');
  bCloseCompute := true;
end;


procedure TPlayMp3Music.N23101Click(Sender: TObject);
begin
  CloseCompute := StrToTime('23:16:00');
  bCloseCompute := true;
end;

procedure TPlayMp3Music.N23401Click(Sender: TObject);
begin
  CloseCompute := StrToTime('23:36:00');
  bCloseCompute := true;
end;

procedure TPlayMp3Music.scrlbrPosScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  position: Int64;
begin
  btnPause.Click;
  position := BASS_ChannelSeconds2Bytes(hs, ScrollPos / 1000);
  BASS_ChannelSetPosition(hs, position, BASS_POS_BYTE);
  dispCurAndMusicTime(Trunc(position / 1000), curMusicTime);
  tmrProgressTimer(nil);
  btnPlayMusic.Click;
end;

procedure TPlayMp3Music.setSpectrum;
begin
  with Spectrum do
  begin
    Width := 3;
    Peak := 16711935;
    LineFallOff := 5;
    PeakFallOff := 2;
    Mode := 1;
    BackColor := 16777088;
    Pen := 16744448;
  end;
end;

procedure TPlayMp3Music.SetSysVolumeWithVolArr;
var
  I: Integer;
  sysvolumn:integer;
  SingVol:single;
begin
  for I := 0 to Length(TimeVolArr) -1 do
    begin
      if Time >= TimeVolArr[i].sTime then
         sysvolumn := TimeVolArr[i].iVolumn;
    end;

  SingVol := 0;

  if sysvolumn >= 0 then  SingVol := sysvolumn / 100;
  if endpointVolume = nil then Exit;
  endpointVolume.SetMasterVolumeLevelScalar(singVol, nil);
  statInfo.Panels[1].Text := '当前系统音量：'+sysvolumn.ToString + '%'
end;

procedure TPlayMp3Music.SetSysVolWithIni;
var
  VolIniFile:string;
  sLines: string;
  FlnmTxt: TextFile;
  i:integer;
begin
  VolIniFile := ExtractFileDir(ParamStr(0)) + '\MyMp3.ini';
  if FileExists(VolIniFile) then
  begin
    AssignFile(FlnmTxt, VolIniFile);
    Reset(FlnmTxt);
    readln(FlnmTxt, sLines);
    if (sLines <> '#This is System Volumn Setting File#') then
    begin
      showmessage('不是正常的音量文件，请联系开发人员！');
      Exit;
    end;
    Readln(FlnmTxt,sLines);

    i:=1;
    while not Eof(FlnmTxt) do
    begin
      Readln(FlnmTxt, sLines);
      if sLines = '' then  Continue;
      sLines := i.ToString + sLines;
      StrsToTimeVol(sLines);
      Inc(i);
    end;
    CloseFile(FlnmTxt);
  end;
end;

procedure TPlayMp3Music.StrsToTimeVol(sTimeVolInfo:string);
var
  strs: TStrings;
  aTimeVol :TTimeVolRec;
  tsttime:TDateTime;
begin
  strs := TStringList.Create;
  strs.Delimiter := '#';
  strs.DelimitedText := sTimeVolInfo;

  if TryStrToTime(strs[1],tsttime) and (strs[2].ToInteger > 0)
         and (strs[2].ToInteger < 100 ) then
    begin
      aTimeVol.iNO     := strs[0].ToInteger;
      aTimeVol.sTime   := StrToTime(strs[1]);
      aTimeVol.iVolumn := strs[2].ToInteger;

      SetLength(TimeVolArr, Length(TimeVolArr) + 1);
      TimeVolArr[Length(TimeVolArr)-1] := aTimeVol;
    end;
  strs.Free;
end;

procedure TPlayMp3Music.TimerRenderTimer(Sender: TObject);
var
  FFTFata: TFFTData;
begin
  if BASS_ChannelIsActive(hs) <> BASS_ACTIVE_PLAYING then
    Exit;

  BASS_ChannelGetData(hs, @FFTFata, BASS_DATA_FFT1024);
  Spectrum.Draw(pbPaintFrame.Canvas.Handle, FFTFata, 0, 0);
end;

procedure TPlayMp3Music.tmrMusLstTimer(Sender: TObject);
var
  StatStr: string;
  i:Integer;
begin
   if (Time > CloseCompute) and
      ((Time > StrToTime('22:00:00')) or (time < strTotime('05:10:00')))
       and bCloseCompute
   then
     begin
       ShutDownComputer;
     end;

   label1.Caption := '[播放：'+CurMusicRec.FileName+ ']'+#10#13
                    + '[当前时间：'+ timetostr(now)+']' ;
      //判断有没有需要立即播放的音乐，
      //有就立即停止当前的播放（SPECMUSICLST）

    if NormalLstDbClk then
       begin

         if Length(NorMusArring) <=0 then exit;
         for i := 0 to Length(NorMusArring) - 1 do
           begin
             NorMusArring[i].playing := false;
           end;
         NorMusArring[CurMusicRec.iSecNo - 1].playing := True;
         if LoadSetMusic(CurMusicRec) then
           btnPlayMusicClick(nil);
         NormalLstDbClk := false;
         Exit;
       end;


   if heartOfChinaPlay then
     begin
       if LoadSetMusic(CurMusicRec) then
          btnPlayMusicClick(nil);
       HeartOfChinaPlay := False;
       exit;
     end;


    if loadSpceMusic then
    begin
      btnPlayMusicClick(nil);
    end;
      //没有的就顺序往下播放(NORMUSICLST)
      //判断前面一首是否已经播放完毕   PlayOrPause = true  and Bass_active_Stopped

  if (Time >StrToTime('08:58:00')) and (time < StrToTime('10:00:00'))   then
    begin
      statInfo.Panels[2].Text := '静音时间！只播指定音乐！';
      exit;
    end;


  if hs = 0 then
  begin
    if LoadSetMusic(GetNextMusic) then
      btnPlayMusicClick(nil);
    exit;
  end;

  case BASS_ChannelIsActive(hs) of
    BASS_ACTIVE_STOPPED:
      begin
        StatStr := '停止状态';
        //载入下一首，并播放；
        if LoadSetMusic(GetNextMusic) then
        begin
          SetSysVolumeWithVolArr;
          btnPlayMusicClick(nil);
        end;
      end;
    BASS_ACTIVE_PLAYING:
      StatStr := '正在播放';
    BASS_ACTIVE_STALLED:
      StatStr := '失速状态, 正在等待数据';
    BASS_ACTIVE_PAUSED:
      StatStr := '暂停状态';
  end;

  statInfo.Panels[2].Text := StatStr;
end;

procedure TPlayMp3Music.tmrProgressTimer(Sender: TObject);
begin
  curPlayTime := Trunc(BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetPosition(hs, BASS_POS_BYTE)));
  dispCurAndMusicTime(curPlayTime,curMusicTime);
  scrlbrPos.Position := curPlayTime * 1000;
end;

procedure TPlayMp3Music.trckbrAttXwChange(Sender: TObject);
var
  pan: Single;
begin
  BASS_ChannelSetAttribute(hs, BASS_ATTRIB_PAN, trckbrAttXw.Position / trckbrAttXw.Max);
  BASS_ChannelGetAttribute(hs, BASS_ATTRIB_PAN, pan);
  pan := trunc(pan * 100);
  lblAttXw.Caption := '当前相位值：' + FormatFloat('0%', pan);
end;

procedure TPlayMp3Music.trckbrVolumeChange(Sender: TObject);
var
  vol: Single;
begin
  BASS_ChannelSetAttribute(hs, BASS_ATTRIB_VOL, trckbrVolume.Position / trckbrVolume.Max);
  BASS_ChannelGetAttribute(hs, BASS_ATTRIB_VOL, vol);
  vol := Trunc(vol * 100);
  lblVolume.Caption := '当前音量值：' + FormatFloat('0%', vol);
end;

procedure TPlayMp3Music.WMMove(var Message: TMessage);
begin
  AlignFormAgain;
end;

end.

