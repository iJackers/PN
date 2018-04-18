unit UntConst;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows;

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
//procedure Get_Shutdown_Privilege;
//function GetOperatingSystem(): string; //获取操作系统信息
procedure ShutDownComputer();

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
  NorMusArring := nil;
  SpecMusArring := nil;
  j := 0;
  for i := 0 to Length(NorMusArr) - 1 do
  begin
    if FileExists(NorMusArr[i].PathName + NorMusArr[i].FileName) then
    begin
      SetLength(NorMusArring, j + 1);
      NorMusArring[j] := NorMusArr[i];
      NorMusArring[j].iSecNo := j+1;
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
      SpecMusArring[j].iSecNo := j+1;
      Inc(j);
    end;
  end;
end;

procedure Get_Shutdown_Privilege; //获得用户关机特权，仅对Windows NT/2000/XP
var
  rl: Cardinal;
  hToken: NativeUInt;
  tkp: TOKEN_PRIVILEGES;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
  if LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid) then
  begin
    tkp.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED;
    tkp.PrivilegeCount:= 1;
    AdjustTokenPrivileges(hToken, False, tkp, 0, nil, rl);
  end;
end;

function GetOperatingSystem(): string; //获取操作系统信息
var
  osVerInfo: TOSVersionInfo;
begin
  Result:= '';
  osVerInfo.dwOSVersionInfoSize:= SizeOf(TOSVersionInfo);

  if GetVersionEx(osVerInfo) then
    case osVerInfo.dwPlatformId of
    VER_PLATFORM_WIN32_NT:
      begin
        Result:= 'WIN_NT'
      end;
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        Result := 'WIN_95/98';
      end;
  end;
end;

procedure ShutDownComputer();
begin
  if GetOperatingSystem() = 'WIN_NT' then
  begin
    Get_Shutdown_Privilege();
    //调用此函数会出现系统关机提示窗口，并允许用户取消关机动作
    InitiateSystemShutDown(nil, '关机提示：讨厌你,哼哼，所以关了你！', 15, True, False);
    // InitiateSystemShutDown去掉的话就不显示提示窗口
    ExitWindowsEx(EWX_SHUTDOWN+EWX_FORCE+EWX_POWEROFF+EWX_FORCEIFHUNG,0);
  end
  else
  begin
    ExitWindowsEx(EWX_SHUTDOWN+EWX_FORCE+EWX_POWEROFF+EWX_FORCEIFHUNG,0);
  end;
end;

end.

