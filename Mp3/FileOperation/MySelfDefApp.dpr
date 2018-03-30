program MySelfDefApp;

uses
  Vcl.Forms,
  MySelfDefDbList in 'MySelfDefDbList.pas' {Form1},
  untFileFmtDef in 'untFileFmtDef.pas',
  untSelfDefFileFmtClass in 'untSelfDefFileFmtClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
