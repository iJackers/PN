unit UntConst;

interface

uses
  System.SysUtils, System.Classes;

type
  TMusicFileRec = record
    iSecNo: Integer;      //��ˮ��
    PathName: string;       //·����
    FileName: string;       //������
    PlayTime: string;       //ָ������ʱ��
    MusicLen: Integer;      //���ֳ���
    PlayTimes: Integer;      //���Ŵ���
    SingleLoop: Boolean;      //����ѭ��
    IsPlay: Boolean;      //�Ƿ񲥷�
    PlayVol: Integer;      //��������
    PLaylfRi: Integer;      //��������
    playing: Boolean;      //������
  end;

  PMusicFileList = ^TMusicFileRec;

var
  SpecMusArr: array of TMusicFileRec;
  SpecMusArring: array of TMusicFileRec;
  NorMusArr: array of TMusicFileRec;
  NorMusArring: array of TMusicFileRec;

procedure StrToMusRec(sMusicInfo: string; var pMusicRec: TMusicFileRec; Sep: string; PwsFlag: boolean);

procedure SetMusicArray;

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
    pMusicRec.IsPlay   := False;
    pMusicRec.PlayTimes:=1;
    pMusicRec.SingleLoop:= False;
    pMusicRec.PlayVol  := 50;
    pMusicRec.PLaylfRi := 0;
    pMusicRec.playing  := False;
  end
  else
  begin
    pMusicRec.iSecNo := strs[0].ToInteger;
    pMusicRec.FileName := ExtractFileName(strs[1]);
    pMusicRec.PathName := ExtractFilePath(strs[1]);
    pMusicRec.MusicLen := strs[2].ToInteger;
    pMusicRec.IsPlay   := False;
    pMusicRec.PlayTimes:=1;
    pMusicRec.SingleLoop:= False;
    pMusicRec.PlayVol  := 50;
    pMusicRec.PLaylfRi := 0;
    pMusicRec.playing  := False;
  end;
  strs.Free;
end;

procedure SetMusicArray;
var
  i, j: integer;
begin
  j := 0;
  for i := 0 to Length(NorMusArr) - 1 do
  begin
    if FileExists(NorMusArr[i].PathName + NorMusArr[i].FileName) then
    begin
      SetLength(NorMusArring, j + 1);
      NorMusArring[j] := NorMusArr[i];
      Inc(j);
    end;
  end;
  if j > 0 then
    NorMusArring[j - 1].playing := true;

  j := 0;
  for i := 0 to Length(SpecMusArr) - 1 do
  begin
    if FileExists(SpecMusArr[i].PathName + specMusArr[i].FileName) then
    begin
      setLength(SpecMusArring, j + 1);
      SpecMusArring[j] := SpecMusArr[i];
      Inc(j);
    end;
  end;
end;

end.

