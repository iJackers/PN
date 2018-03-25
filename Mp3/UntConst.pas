unit UntConst;

interface

uses
  System.SysUtils,  System.Classes;

type

 TMusicFileRec = record
   iSecNo     :Integer;      //��ˮ��
   PathName   :string;       //·����
   FileName   :string;       //������
   PlayTime   :string;       //ָ������ʱ��
   MusicLen   :Integer;      //���ֳ���
   PlayTimes  :Integer;      //���Ŵ���
   SingleLoop :Boolean;      //����ѭ��
   IsPlay     :Boolean;      //�Ƿ񲥷�
   PlayVol    :Integer;      //��������
   PLaylfRi   :Integer;      //��������
   playing    :Boolean;      //������
 end;

 PMusicFileList = ^TMusicFileRec;

procedure  StrToMusRec(sMusicInfo: string; var pMusicRec: TMusicFileRec; Sep: string; PwsFlag: boolean);

implementation

procedure StrToMusRec(sMusicInfo: string; var pMusicRec: TMusicFileRec; Sep: string; PwsFlag: boolean);
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  strs.Delimiter := '#';
  strs.DelimitedText := sMusicInfo;
  if PwsFlag then
    begin
      pMusicRec.iSecNo := strs[0].ToInteger;
      pMusicRec.PlayTime := strs[1];
      pMusicRec.FileName := ExtractFileName(strs[2]);
      pMusicRec.PathName := ExtractFilePath(strs[2]);
      pMusicRec.MusicLen := strs[3].ToInteger;
    end
  else
    begin
      pMusicRec.iSecNo := strs[0].ToInteger;
      pMusicRec.FileName := ExtractFileName(strs[1]);
      pMusicRec.PathName := ExtractFilePath(strs[1]);
      pMusicRec.MusicLen := strs[2].ToInteger;
    end;
  strs.Free;
end;

end.
