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
  Application.Title := '�ϲ���ʢ�ſ�MP3��ʱ������';
  Application.CreateForm(TPlayMp3Music, PlayMp3Music);
  Application.Run;
end.
