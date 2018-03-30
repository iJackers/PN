unit untFileFmtDef;

interface

uses
  System.SysUtils;

type
  sFileHead = record             //文件头
    CreateDt: TDateTime;         //创建时间
    FileVer: string[10];         //格式版本
    GoTheKey: string[20];        //密匙
  end;

  IndexHead = record             //索引头
    absIndexNum: Cardinal;       //最大的索引值
    GoodIdxTNum: Word;           //有效索引总数
    GoodIdxPos: Cardinal;        //第一个有效索引位置
    BadIdxTNum: Word;            //无效索引总数
    BadIdxPos: Cardinal;         //第一个无效索引位置
    LastGoodIdxPos: Cardinal;    //最后一个有效索引的位置
    LastBadIdxPos: Cardinal;     //最后一个无效索引的位置
  end;

  IndexBody = record
    IdxID: Cardinal;         //索引号
    PreIdxPos: Cardinal;     //上一个索引位置
    IsValidIdx: Boolean;     //是否有效
    SelfIdxPos: Cardinal;    //自身位置
    ContentPos: Cardinal;    //内容所在位置
    ContentLen: Cardinal;    //内容长度
    NextIdxPos: Cardinal;    //下一个索引位置
  end;

  FileContentDef = record
    Kind: Byte;             //分类
    ParentID: Cardinal;     //父节点标示

    iSecNo: Integer;        //流水号
    PathName: string;       //路径名
    FileName: string;       //音乐名
    PlayTime: string;       //指定播放时间
    MusicLen: Integer;      //音乐长度
    PlayTimes: Integer;     //播放次数
    SingleLoop: Boolean;    //单曲循环
    IsPlay: Boolean;        //是否播放
    PlayVol: Integer;       //播放音量
    PLaylfRi: Integer;      //左右声道
    playing: Boolean;       //播放中
  end;

const
  cstFileName = 'MusicList';
  cstExt = 'Pws';
  CstVer = '1.01.001';
  cstError = -1;
  cstFine = 0;
  cstNotExist = 0;

implementation

end.

