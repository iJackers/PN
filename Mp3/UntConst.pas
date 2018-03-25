unit UntConst;

interface

uses
  System.SysUtils,  System.Classes;

type

 TMusicFileRec = record
   iSecNo     :Integer;      //流水号
   PathName   :string;       //路径名
   FileName   :string;       //音乐名
   PlayTime   :string;       //指定播放时间
   MusicLen   :Integer;      //音乐长度
   PlayTimes  :Integer;      //播放次数
   SingleLoop :Boolean;      //单曲循环
   IsPlay     :Boolean;      //是否播放
   PlayVol    :Integer;      //播放音量
   PLaylfRi   :Integer;      //左右声道
   playing    :Boolean;      //播放中
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
