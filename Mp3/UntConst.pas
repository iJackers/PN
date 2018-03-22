unit UntConst;

interface

type

 TMusicFileList = record
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

 PMusicFileList = ^TMusicFileList;


implementation

end.
