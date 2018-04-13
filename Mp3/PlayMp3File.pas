unit PlayMp3File;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bass, Vcl.ComCtrls, Vcl.StdCtrls,
  DispatchMp3File, Vcl.ExtCtrls, Vcl.Buttons, spectrum_vis, Vcl.Imaging.pngimage,
  System.DateUtils, UntConst;

type
  TPlayMp3Music = class(TForm)
    statInfo: TStatusBar;
    pnlBtn: TPanel;
    btnPlayMusic: TBitBtn;
    btnPause: TBitBtn;
    btnStop: TBitBtn;
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
    procedure FormCreate(Sender: TObject);
    procedure btnPlayMusicClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
    procedure scrlbrPosScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure trckbrVolumeChange(Sender: TObject);
    procedure trckbrAttXwChange(Sender: TObject);
    procedure TimerRenderTimer(Sender: TObject);
    procedure tmrMusLstTimer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    CurMusicRec: TMusicFileRec;
    curPlayTime, curMusicTime: double;
    PlayingNotStop: boolean;
    heartOfChinaPlay :Boolean;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
    procedure dispCurAndMusicTime(curtime, curalltime: Double);
    procedure setSpectrum;
    procedure AlignFormAgain;
    function CheckMustPlayImm: Boolean;
    function GetNextMusic: TMusicFileRec;
    function LoadSetMusic(sSetMusic: TMusicFileRec): Boolean;
    function loadSpceMusic: Boolean;
  public
    { Public declarations }
  end;

var
  PlayMp3Music: TPlayMp3Music;
  Mp3Lstfrm: TMp3Lstfrm;
  hs: dword; {流句柄}

implementation

{$R *.dfm}

procedure TPlayMp3Music.AlignFormAgain;
begin
  if not Assigned(Mp3Lstfrm) then
    exit;
  if Mp3Lstfrm.Visible = False then
    Mp3Lstfrm.Show;
  Mp3Lstfrm.Left := Self.Left + self.Width + 10;
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
  btnStopClick(nil);
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
  trckbrVolumeChange(nil);
  trckbrAttXwChange(nil);
end;

procedure TPlayMp3Music.btnStopClick(Sender: TObject);
begin
  BASS_ChannelStop(hs);
  tmrProgress.Enabled := false;
  tmrMusLst.Enabled := False;
end;

function TPlayMp3Music.CheckMustPlayImm: Boolean;
begin
  result := true;
end;

procedure TPlayMp3Music.dispCurAndMusicTime(curtime, curalltime: Double);
var
  sCurTime, sCurAllTime, sCurLstTime: string;
  sCurTime60, sCurAllTime60: string;
begin
  sCurTime := FormatFloat('0.00', curtime);
  sCurAllTime := FormatFloat('0.00', curalltime);
  sCurTime60 := FormatFloat('0.00', curtime/60);
  sCurAllTime60 := FormatFloat('0.00', curalltime/60);
  sCurLstTime := Concat('[',sCurAllTime, '/', sCurTime,']','--','[',sCurAllTime60, '/', sCurTime60,']');
  statInfo.Panels[3].Text := sCurLstTime;
end;

procedure TPlayMp3Music.FormCreate(Sender: TObject);
begin

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
    curMusicTime := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetLength(hs, BASS_POS_BYTE)); {总秒数}
    scrlbrPos.Max := Trunc(curMusicTime * 1000);
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

procedure TPlayMp3Music.scrlbrPosScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  position: Int64;
begin
  btnPause.Click;
  position := BASS_ChannelSeconds2Bytes(hs, ScrollPos / 1000);
  BASS_ChannelSetPosition(hs, position, BASS_POS_BYTE);
  dispCurAndMusicTime((position / 1000), curMusicTime);
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
begin
   label1.Caption := '['+CurMusicRec.FileName+']-[' + timetostr(now)+']' ;
      //判断有没有需要立即播放的音乐，
      //有就立即停止当前的播放（SPECMUSICLST）

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

  if (Time >StrToTime('00:00:00')) and (time < StrToTime('10:00:00'))   then
    begin
      label1.Caption := '静音时间！';
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
          btnPlayMusicClick(nil);
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
  curPlayTime := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetPosition(hs, BASS_POS_BYTE));
  dispCurAndMusicTime(curMusicTime, curPlayTime);
  scrlbrPos.Position := Trunc(curPlayTime * 1000);
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

