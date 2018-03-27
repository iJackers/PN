///////////////////////////////////////////////////////////////////////////////
//此单元为定义文件格式单元                                                  //
//建立日期为2004年8月24日                                                  //
//当前版本号为v1.0                                                        //
//创建人mmzmagic   QQ 22900104   有啥意见一起讨论哈                      //
//////////////////////////////////////////////////////////////////////////
Unit PFormatDefine;

Interface

Uses SysUtils;
Type
  RFileHead = Packed Record //文件头
    MCreateTime: TDateTime; //创建时间
    MvisonNum: Shortint; //格式版本号
    MThekey: String[10]; //密匙
  End;
  RIdxHead = Packed Record
    MAbsIndxID: Cardinal; //绝对的索引最大值
    MGoodIdx: Word; //有效索引数
    Mgoodidxpos: Cardinal; //第一个有效索引的位置
    MbadIdx: Word; //无效索引数
    MbadidxPos: Cardinal; //第一个无效索引的位置
    MlastGoodidxPos: Cardinal; //最后一个有效索引的位置
    MLastBadIDxPos: Cardinal; //最后一个无效索引的位置
  End;
  Rindex = Packed Record //索引
    MIdxId: Cardinal; //索引的ID号
    MupIdxPos: Cardinal; //上一个索引的位置 如果为-1 那么就是第1个索引
    MisGoodIdx: Boolean; //索引是否有效
    MselfidxPos: Cardinal; //自己的位置
    MContentPos: Cardinal; //内容所在位置
    MContentlen: Cardinal; //所包含的内容长度
    MnextIdxPos: Cardinal; //下一个索引的位置 如果为-1 那么就是第1个索引
  End;
  RFileContentFmt = Packed Record //内容格式
    Mkind: Byte; //标示文件的类别
    MParentId: Cardinal; //父节点的唯一标示
    MCaption: String[60]; //标题
    MKindStr: String[20]; //类别
  End;
Const
  CimgIdxDir = 1; //3种节点类型
  CimgIdxFile = 2;
  CimgIdxIE = 3;
  CstFileName = 'DB'; //文件名
  CstExt = '.mmz'; //文件扩展名
  CstCurrvon = 1; //当前版本号
  CstError = 0; //返回错误
  CstFine = 1; // 返回正确
  CstNotExits = 0; //不存在

Implementation

End.
