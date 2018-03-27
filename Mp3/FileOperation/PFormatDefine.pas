///////////////////////////////////////////////////////////////////////////////
//此单元为定义文件格式单元                                                  //
//建立日期为2004年8月24日                                                  //
//当前版本号为v1.0                                                        //
//创建人mmzmagic   QQ 22900104   有啥意见一起讨论哈                      //
//////////////////////////////////////////////////////////////////////////
unit PFormatDefine;

interface

uses
  SysUtils;

type
  SelfDefFileHead = record //文件头
    CreateDT: TDateTime; //创建时间
    VersionStr: string[10]; //格式版本号
    GoTheKey: string[30]; //密匙
  end;

  IndexHead = record //索引头
    GoodIdxCount: Integer; //有效索引数
    GoodFirstIdxPos: Integer; //第一个有效索引的位置
    BadIdxCount: Integer; //无效索引数
    BadFirstIdxPos: Integer; //第一个无效索引的位置
    LastGoodIdxPos: Integer; //最后一个有效索引的位置
    LastBadIdxPos: Integer; //最后一个无效索引的位置
  end;

  IndexBody = record //索引
    UpIdxPos: integer; //上一个索引的位置 如果为-1 那么就是第1个索引
    IsGoodIdx: Boolean; //索引是否有效
    IdxAils: string[20]; //索引别名
    CurIdxPos: Integer; //自己的位置
    CurContentPos: Integer; //内容所在位置
    CurContentLen: Integer; //所包含的内容长度
    NextIdxPos: Integer; //下一个索引的位置 如果为-1 那么就是第1个索引
  end;

  RecContentFmt = record //内容格式
    Kind: Byte; //移动联通
    CaptionLen: string[20]; //标题长度
  end;

  GetDataList = record  //元素结构
    DataCaption: string;  //元素标题
    DataIdxPos: Integer;  //元素索引位子
  end;

type
  DarrayList = array of GetDataList;  //动态列表 获取所有元素使用的

const
  CnstFileExt = 'pwf'; //文件扩展名
  CnstCurExeVer = '1.0.0.1'; //当前版本号
  CnstError = -1; //返回错误
  CnstFine = 0; // 返回正确
  CnstNotExits = -1;

implementation

end.

