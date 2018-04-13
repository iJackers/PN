unit UntConst;

interface

uses
  System.SysUtils, System.Classes;

type
  TMusicFileRec = record
    iSecNo: Integer;      //流水号
    PathName: string;       //路径名
    FileName: string;       //音乐名
    PlayTime: string;       //指定播放时间
    MusicLen: Integer;      //音乐长度
    PlayTimes: Integer;      //播放次数
    SingleLoop: Boolean;      //单曲循环
    IsPlay: Boolean;      //是否播放
    PlayVol: Integer;      //播放音量
    PLaylfRi: Integer;      //左右声道
    playing: Boolean;      //播放中
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
    pMusicRec.IsPlay   := strs[4].toboolean;
    pMusicRec.PlayTimes:=strs[5].ToInteger;
    pMusicRec.SingleLoop:= strs[6].ToBoolean;
    pMusicRec.PlayVol  := strs[7].ToInteger;
    pMusicRec.PLaylfRi := strs[8].ToInteger;
    pMusicRec.playing  := strs[9].ToBoolean;
  end
  else
  begin
    pMusicRec.iSecNo := strs[0].ToInteger;
    pMusicRec.FileName := ExtractFileName(strs[1]);
    pMusicRec.PathName := ExtractFilePath(strs[1]);
    pMusicRec.MusicLen := strs[2].ToInteger;
    pMusicRec.IsPlay   := strs[3].toboolean;
    pMusicRec.PlayTimes:=strs[4].ToInteger;
    pMusicRec.SingleLoop:= strs[5].ToBoolean;
    pMusicRec.PlayVol  := strs[6].ToInteger;
    pMusicRec.PLaylfRi := strs[7].ToInteger;
    pMusicRec.playing  := strs[8].ToBoolean;
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

