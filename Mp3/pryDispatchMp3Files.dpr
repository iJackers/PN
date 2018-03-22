program pryDispatchMp3Files;

uses
  Vcl.Forms,
  DispatchMp3File in 'DispatchMp3File.pas' {Mp3Lstfrm},
  UntConst in 'UntConst.pas',
  PlayMp3File in 'PlayMp3File.pas' {PlayMp3Music},
  Vcl.Themes,
  Vcl.Styles,
  bass in 'bass.pas',
  spectrum_vis in 'spectrum_vis.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '南昌百盛优客MP3定时播放器';
  Application.CreateForm(TPlayMp3Music, PlayMp3Music);
  Application.Run;
end.
