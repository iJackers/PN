Program PLoveCon;

Uses
  Forms,
  PMain In 'PMain.pas' {Main},
  PFormatDefine In 'PFormatDefine.pas',
  PSelffileClass In 'PSelffileClass.pas',
  PMyColoctTreeImp In 'PMyColoctTreeImp.pas',
  PGetMapTree In 'PGetMapTree.pas';

{$R *.res}

Begin
  Application.Initialize;
  Application.Title := ' ’ºØ–°»Ì';
  Application.CreateForm(TMain, Main);
  Application.Run;
End.

