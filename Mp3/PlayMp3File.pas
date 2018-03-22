unit PlayMp3File;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bass, Vcl.ComCtrls, Vcl.StdCtrls, DispatchMp3File,
  Vcl.ExtCtrls, Vcl.Buttons,spectrum_vis, Vcl.Imaging.pngimage;

type
  TPlayMp3Music = class(TForm)
    statInfo: TStatusBar;
    pnlBtn: TPanel;
    btnLoadLst: TBitBtn;
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
    procedure FormCreate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure btnPlayMusicClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnLoadLstClick(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
    procedure scrlbrPosScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure trckbrVolumeChange(Sender: TObject);
    procedure trckbrAttXwChange(Sender: TObject);
    procedure TimerRenderTimer(Sender: TObject);
    procedure tmrMusLstTimer(Sender: TObject);
  private
    { Private declarations }
    mp3path :string;
    curPlayTime,curMusicTime:double;

    PlayOrPause:boolean;
    procedure WMMove(var Message: TMessage) ; message WM_MOVE;
    procedure dispCurAndMusicTime(curtime,curalltime:Double);
    procedure setSpectrum;
    procedure AlignFormAgain;
    function CheckMustPlayImm:Boolean;
  public
    { Public declarations }
  end;

var
  PlayMp3Music: TPlayMp3Music;
  Mp3Lstfrm:TMp3Lstfrm;
  hs: dword; {流句柄}


implementation

{$R *.dfm}

procedure TPlayMp3Music.AlignFormAgain;
begin
  if not Assigned(Mp3Lstfrm) then   exit;
  if Mp3Lstfrm.Visible = False then  Mp3Lstfrm.Show;
  Mp3Lstfrm.Left := Self.Left + Width ;
  Mp3Lstfrm.Top := self.Top;
  Mp3Lstfrm.AlphaBlendValue := Self.AlphaBlendValue;
  Mp3Lstfrm.Height :=Self.Height;
end;

procedure TPlayMp3Music.btnLoadLstClick(Sender: TObject);
begin
  if Assigned(Mp3Lstfrm.lvSpecLst.Items.Item[0]) then
    begin
       mp3path := PChar(Mp3Lstfrm.lvSpecLst.Items.Item[0].SubItems[1]);
       if Not FileExists(mp3path) then
         begin
           statInfo.Panels[0].Text := 'Mp3文件不存在！';
           exit;
         end
       else
         begin
           statInfo.Panels[0].Text := ExtractFileName(Mp3Path);
         end;
    end
  else
    begin
      statInfo.Panels[0].Text := '检查播放列表!';
      exit;
    end;

  BASS_StreamFree(hs);

  hs:= BASS_StreamCreateFile(False, PChar(Mp3Path), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  if hs < BASS_ERROR_ENDED then
    statInfo.Panels[0].Text := '打开失败'
  else begin
    curMusicTime := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetLength(hs, BASS_POS_BYTE)); {总秒数}
    scrlbrPos.Max := Trunc(curMusicTime * 1000);
    Mp3Lstfrm.lvSpecLst.Items.Item[0].SubItems[2] := Trunc(curMusicTime).ToString;
    //保存音乐时间
    scrlbrPos.Enabled := True;
  end;

end;

procedure TPlayMp3Music.btnPauseClick(Sender: TObject);
begin
  tmrProgress.Enabled := False;
  BASS_ChannelPause(hs);
  PlayOrPause := false;
end;

procedure TPlayMp3Music.btnPlayMusicClick(Sender: TObject);
begin
  BASS_ChannelPlay(hs, False);
  tmrProgress.Enabled := true;
  trckbrVolumeChange(nil);
  trckbrAttXwChange(nil);
  PlayOrPause := true;
end;

procedure TPlayMp3Music.btnStopClick(Sender: TObject);
begin
  BASS_ChannelStop(hs);
  tmrProgress.Enabled := false;
  PlayOrPause := false;
end;

function TPlayMp3Music.CheckMustPlayImm: Boolean;
begin
  result:= false;
end;

procedure TPlayMp3Music.dispCurAndMusicTime(curtime, curalltime: Double);
var
  sCurTime,sCurAllTime,sCurLstTime:string;
begin
  sCurTime := FormatFloat('0.00',curtime);
  sCurAllTime := FormatFloat('0.00',curalltime);
  sCurLstTime := Concat(sCurAllTime, '/' ,sCurTime);
  statInfo.Panels[3].Text := sCurLstTime;
end;

procedure TPlayMp3Music.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  //if (NewHeight <100) or (NewWidth < 580) then Resize := False;
end;

procedure TPlayMp3Music.FormCreate(Sender: TObject);
begin

  if HiWord(BASS_GetVersion) <> BASSVERSION then
    MessageBox(0, '"Bass.dll" 文件版本不合适! ', nil, MB_ICONERROR);

  if not BASS_Init(-1, 44100, 0, 0, nil) then
    ShowMessage('初始化错误');

  Mp3Lstfrm := TMp3Lstfrm.Create(Application);
  Mp3Lstfrm.Show;

  Spectrum    := TSpectrum.Create(pbPaintFrame.Width, pbPaintFrame.Height);
  setSpectrum;
  AlignFormAgain;

  PlayOrPause := false;
end;

procedure TPlayMp3Music.FormDestroy(Sender: TObject);
begin
  BASS_Free;
end;


procedure TPlayMp3Music.scrlbrPosScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  position:Int64;
begin
  btnPause.Click;
  Position := BASS_ChannelSeconds2Bytes(hs, ScrollPos / 1000);
  BASS_ChannelSetPosition(hs, Position, BASS_POS_BYTE);
  dispCurAndMusicTime((Position / 1000),curMusicTime);
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
  FFTFata : TFFTData;
  WaveData  : TWaveData;
begin
 if BASS_ChannelIsActive(hs) <> BASS_ACTIVE_PLAYING then Exit;

  BASS_ChannelGetData(hs, @FFTFata, BASS_DATA_FFT1024);
  Spectrum.Draw(pbPaintFrame.Canvas.Handle, FFTFata, 0, 0);
end;

procedure TPlayMp3Music.tmrMusLstTimer(Sender: TObject);
var
  StatStr:string;
begin
  if not PlayorPause then  exit;


  if CheckMustPlayImm then
    begin
      //判断有没有需要立即播放的音乐，
      //有就立即停止当前的播放（SPECMUSICLST）

      btnStopClick(nil);

  //没有的就顺序往下播放(NORMUSICLST)
  //判断前面一首是否已经播放完毕   PlayOrPause = true  and Bass_active_Stopped
  //
    end;
  if hs = 0 then Exit; {如果播放流没有建立则退出}


  case BASS_ChannelIsActive(hs) of
    BASS_ACTIVE_STOPPED:
      begin
        StatStr := '停止状态';
        //载入下一首，并播放；





      end;
    BASS_ACTIVE_PLAYING: StatStr := '正在播放';
    BASS_ACTIVE_STALLED: StatStr := '失速状态, 正在等待数据';
    BASS_ACTIVE_PAUSED:  StatStr := '暂停状态';
  end;
  statInfo.Panels[2].Text := StatStr;

end;

procedure TPlayMp3Music.tmrProgressTimer(Sender: TObject);
begin
  curPlayTime := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetPosition(hs, BASS_POS_BYTE));
  dispCurAndMusicTime(curMusicTime,curPlayTime);
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
  vol := Trunc(vol *100);
  lblVolume.Caption := '当前音量值：' + FormatFloat('0%', vol);
end;

procedure TPlayMp3Music.WMMove(var Message: TMessage);
begin
  AlignFormAgain;
end;

end.
