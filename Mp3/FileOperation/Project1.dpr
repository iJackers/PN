program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PFormatDefine in 'PFormatDefine.pas',
  PSelffileClass in 'PSelffileClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
