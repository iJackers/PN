///////////////////////////////////////////////////////////////////////////////
//此单元为定义文件类单元                                                    //
//建立日期为2004年8月24日                                                  //
//当前版本号为v1.0                                                        //
//创建人mmzmagic   QQ 22900104   有啥意见一起讨论哈                      //
//////////////////////////////////////////////////////////////////////////
//自定义文件操作基类
unit PSelffileClass;

interface

uses
  PformatDefine, Classes, ZLib;
type
  TSelfFileBassClass = class
  private
    Fziplv: TCompressionLevel; //压缩等级
    Ffilename: string; //保存的文件名属性
    FOpreater: Tfilestream; //操作流
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure AfterCreate; virtual; //新文件创建后加入文件头
  protected
    //申请几个缓冲区
    LRhead: RFileHead;
    LRidx: RIdxHead;
    Lindex: Rindex;
    LFmt: RFileContentFmt;
  public
    property ZipLv: TCompressionLevel read Fziplv write Fziplv default clMax;
    property OPreater: TFileStream read FOpreater write FOpreater;
    procedure EnCompressStream(CompressedStream: TMemoryStream);
    procedure DeCompressStream(CompressedStream: TMemoryStream);
    property FileName: string read FFileName write FFileName;
    constructor Create(Ifilename: string);
    destructor Destroy; override;
  end;
type
  IIndexHead = interface
    function GetAbsIndx: Cardinal;
    procedure setABSIndx(Value: Cardinal);
    function getgoodidx: Integer;
    procedure SetGoodidx(value: Integer);
    function Getgoodidxpos: Integer;
    procedure Setgoodidxpos(value: Integer);
    function GetMbadIdx: Integer;
    procedure SetMbadIdx(value: Integer);
    function GetbadidxPos: Integer;
    procedure SetbadidxPos(value: Integer);
    function getLastgoodidxPos: Integer;
    procedure SetLastGoodidxPos(value: Integer);
    function getLastbadidxPos: Integer;
    procedure SetLastbadidxPos(value: Integer);
    property GoodIdxCount: Integer read getgoodidx write SetGoodidx;
    property Goodidxpos: Integer read Getgoodidxpos write Setgoodidxpos;
    property BadIdxCount: Integer read GetMbadIdx write SetMbadIdx;
    property BadidxPos: Integer read GetbadidxPos write SetbadidxPos;
    property LastGoodIdxPos: Integer read getLastgoodidxPos write setLastgoodidxPos; //属性 最后的好索引的位置
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos; // 属性 最后的坏索引的位置
  end;
  TSelfFileClass = class(TSelfFileBassClass, IIndexHead)
  private
    FIndexHead: IIndexHead;
    FIdxHead: RIdxHead; //用来中转保索引头性
    function GetHeadIdx: RIdxHead; //获取索引头
    procedure SetHeadIdx(value: RIdxHead); //更新索引头
    function GetAbsIndx: Cardinal;
    procedure setABSIndx(Value: Cardinal);
    function getgoodidx: Integer;
    procedure SetGoodidx(value: Integer);
    function Getgoodidxpos: Integer;
    procedure Setgoodidxpos(value: Integer);
    function GetMbadIdx: Integer;
    procedure SetMbadIdx(value: Integer);
    function GetbadidxPos: Integer;
    procedure SetbadidxPos(value: Integer);
    function getLastgoodidxPos: Integer;
    procedure SetLastGoodidxPos(value: Integer);
    function getLastbadidxPos: Integer;
    procedure SetLastbadidxPos(value: Integer);
  protected
    property AbsId: Cardinal read GetAbsIndx write setABSIndx default 0;
    property GoodIdxCount: Integer read getgoodidx write SetGoodidx default 0;
    property Goodidxpos: Integer read Getgoodidxpos write Setgoodidxpos default CstNotExits;
    property BadIdxCount: Integer read GetMbadIdx write SetMbadIdx default 0;
    property BadidxPos: Integer read GetbadidxPos write SetbadidxPos default CstNotExits;
    property LastGoodIdxPos: Integer read getLastgoodidxPos write setLastgoodidxPos default -1; //属性 最后的好索引的位置
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos default -1; // 属性 最后的坏索引的位置
    // 是它们的集合
    function AddIndex(Iindex: Rindex): Byte; //添加索引
    function AddContentFmt(IFmt: RFileContentFmt): byte; //添加内容头
    function AddContent(var Buff: TMemoryStream): byte; //添加内容
    function ModfyIndex(ReIIndex: Rindex): byte; //修改索引
  public
    property IndexHead: IIndexHead read FIndexHead write FIndexHead;
    //下面3个函数是一组顺序操作 可以取出一条数据 使用时先要设置好读取位置
    function GetIndex(Ipos: integer): Rindex; //根据位置取得索引
    function GetFmt: RFileContentFmt; //取得索引后边的内容头
    function GetContent(var Buff: TMemoryStream): byte; //取得内容
    function IsRightFile: boolean; //文件格式是否是正确
    function AddItems(IFmt: RFileContentFmt; var IBuff: TMemoryStream; const IOldAbsID: Cardinal = 0): Cardinal; //添加子项
    function DeleteItem(IIdxPos: Integer): byte; //根据索引号删除记录
    function UpdateItem(IidxPos: Integer; IFmt: RFileContentFmt; var IBuff: TMemoryStream): Integer; //更新项
    procedure OptimizeDataBase; //优化数据库
    procedure GetItemsDarray(IList: TStringList); //获取元素列表
    function GetIdxPosWithCpt(ICaption: string): Integer; //根据标题获得第一个存在的位置
    constructor Create(Ifilename: string);
    destructor Destroy; override;
  end;

implementation

uses SysUtils, PMyColoctTreeImp;

{ TSelfFileClass }

function TSelfFileClass.AddContent(var Buff: TMemoryStream): byte;
begin
  Result := CstFine;
  if Buff.Size <= 0 then Exit;
  with OPreater do begin
    Write(Buff.memory^, Buff.Size);
  end; // with
end;

function TSelfFileClass.AddContentFmt(IFmt: RFileContentFmt): byte;
begin
  Result := CstFine;
  with OPreater do begin
    Write(Ifmt, sizeof(IFmt));
  end; // with
end;

function TSelfFileClass.AddIndex(Iindex: Rindex): byte;
begin
  Result := CstFine;
  with OPreater do begin
    OPreater.Seek(0, soEnd);
    Write(Iindex, sizeof(Iindex));
  end; // with
end;

function TSelfFileClass.AddItems(IFmt: RFileContentFmt;
  var IBuff: TMemoryStream; const IOldAbsID: Cardinal = 0): Cardinal;
var
  TepIndex: Rindex;
begin
  EnCompressStream(IBuff);
  if IOldAbsID = 0 then begin
    AbsID := AbsId + 1;
    Lindex.MIdxId := AbsId;
  end
  else lindex.MIdxId := IOldAbsID;
  Result := lindex.MIdxId;
  if (GoodIdxCount = 0) and (BadIdxCount = 0) then begin //如果是第1条记录纪录一下第1个索引的位置
    Goodidxpos := sizeof(LRhead) + sizeof(LRidx);
    Lindex.MupIdxPos := CstNotExits;
    Lindex.MisGoodIdx := True;
    Lindex.MselfidxPos := OPreater.Seek(0, soEnd);
    Lindex.MContentPos := sizeof(LRhead) + sizeof(LRidx) + sizeof(Lindex);
    Lindex.MContentlen := IBuff.Size;
    Lindex.MnextIdxPos := CstNotExits;
  end
  else begin //不是第一条记录
    Lindex.MupIdxPos := LastGoodIdxPos;
    Lindex.MisGoodIdx := True;
    Lindex.MselfidxPos := OPreater.Seek(0, soEnd);
    {20050516 add解决删除完添加无效的问题}
    if Goodidxpos = CstNotExits then Goodidxpos := Lindex.MselfidxPos;
    Lindex.MContentPos := Lindex.MselfidxPos + sizeof(Lindex);
    Lindex.MContentlen := IBuff.Size;
    Lindex.MnextIdxPos := CstNotExits;
    if Lindex.MupIdxPos <> CstNotExits then begin
      TepIndex := GetIndex(Lindex.MupIdxPos); //更新上一个索引的下接位置
      TepIndex.MnextIdxPos := Lindex.MselfidxPos;
      ModfyIndex(TepIndex);
    end;
  end;
  LastGoodIdxPos := Lindex.MselfidxPos; //记录最后一个索引的位置
  AddIndex(lindex); //添加索引
  AddContentFmt(IFmt); //写入内容头
  AddContent(IBuff); //写入内容体
  GoodIdxCount := GoodIdxCount + 1;
end;

procedure TSelfFileBassClass.AfterCreate;
begin
  LRhead.MCreateTime := now;
  LRhead.MvisonNum := CstCurrvon;
  LRhead.MThekey := 'mmzmagic';
  LRidx.MGoodIdx := 0;
  LRidx.Mgoodidxpos := CstNotExits;
  LRidx.MbadIdx := 0;
  LRidx.MbadidxPos := CstNotExits;
  LRidx.MlastGoodidxPos := CstNotExits;
  LRidx.MLastBadIDxPos := CstNotExits;
  with OPreater do begin
    Position := 0;
    Write(lrhead, sizeof(LRhead));
    Write(Lridx, Sizeof(LRidx));
  end;
end;

constructor TSelfFileBassClass.Create(Ifilename: string);
begin
  Ffilename := Ifilename;
  ZipLv := clMax;
  if FileExists(Ifilename) then
    FOpreater := TFileStream.Create(Ifilename, fmOpenReadWrite)
  else begin
    FOpreater := TFileStream.Create(Ifilename, fmCreate);
    afterCreate;
  end;
end;

destructor TSelfFileBassClass.Destroy;
begin
  FreeAndNil(FOpreater);
  inherited;
end;

////压缩流，参数：要压缩的流////

procedure TSelfFileBassClass.EnCompressStream(CompressedStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
  Count: int64; //注意，此处修改了,原来是int
begin
  if CompressedStream.Size <= 0 then exit;
  CompressedStream.Position := 0;
  Count := CompressedStream.Size; //获得流的原始尺寸
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(zipLV, DM);
  try
    CompressedStream.SaveToStream(SM); //SourceStream中保存着原始的流
    SM.Free; //将原始流进行压缩，DestStream中保存着压缩后的流
    CompressedStream.Clear;
    CompressedStream.WriteBuffer(Count, SizeOf(Count)); //写入原始文件的尺寸
    CompressedStream.CopyFrom(DM, 0); //写入经过压缩的流
    CompressedStream.Position := 0;
  finally
    DM.Free;
  end;
end;

////解压缩流，参数：要解压的流////

procedure TSelfFileBassClass.DeCompressStream(CompressedStream: TMemoryStream);
var
  MS: TDecompressionStream;
  Buffer: PChar;
  Count: int64;
begin
  if CompressedStream.Size <= 0 then exit;
  CompressedStream.Position := 0; //复位流指针
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  //从被压缩的文件流中读出原始的尺寸
  GetMem(Buffer, Count); //根据尺寸大小为将要读入的原始流分配内存块
  MS := TDecompressionStream.Create(CompressedStream);
  try
    MS.ReadBuffer(Buffer^, Count);
    //将被压缩的流解压缩，然后存入 Buffer内存块中
    CompressedStream.Clear;
    CompressedStream.WriteBuffer(Buffer^, Count); //将原始流保存至 MS流中
    CompressedStream.Position := 0; //复位流指针
  finally
    FreeMem(Buffer);
  end;
end;

function TSelfFileClass.GetContent(var Buff: TMemoryStream): byte;
begin
  Result := CstFine;
  with OPreater do begin
    Read(buff.memory^, buff.Size);
    DeCompressStream(Buff);
  end; // with
end;

function TSelfFileClass.GetFmt: RFileContentFmt;
begin
  with OPreater do begin
    Read(Result, sizeof(Result));
  end; // with
end;

function TSelfFileClass.GetIndex(Ipos: integer): Rindex;
begin
  with OPreater do begin
    Position := Ipos;
    ReadBuffer(Result, sizeof(Result));
  end; // with
end;

function TSelfFileClass.IsRightFile: boolean;
begin
  Result := True;
  with OPreater do begin
    Position := 0;
    Read(lRhead, sizeof(LRhead));
    if LRhead.MThekey <> 'mmzmagic' then
      Result := False;
  end; // with
end;

function TSelfFileClass.ModfyIndex(ReIIndex: Rindex): byte;
begin
  Result := CstFine;
  with OPreater do begin
    Position := ReIIndex.MselfidxPos;
    WriteBuffer(reiindex, sizeof(reiindex));
  end; // with
end;

function TSelfFileClass.DeleteItem(IIdxPos: Integer): byte;
  procedure CheckIsFirstGoodIdx(IUpPos, ICurPos, INextPos: Integer); //处理好索引
    procedure CheckLastGoodIdx(IUpPos, ICurPos, IWillChanged: Integer); //处理是否是最后一个好索引的情况
    begin
      if LastGoodIdxPos = ICurPos then LastGoodIdxPos := IWillChanged;
      if LastGoodIdxPos = CstNotExits then LastGoodIdxPos := IUpPos;
    end;
  var
    TepIdx: Rindex;
  begin
    if ICurPos = Goodidxpos then begin //如果删除的是第1个好索引
      if INextPos <> CstNotExits then begin //有下一个就变更下一个索引为第1索引
        TepIdx := GetIndex(INextPos);
        TepIdx.MupIdxPos := CstNotExits;
        ModfyIndex(TepIdx);
      end;
      Goodidxpos := INextPos; //变更第1个好索引的情况
    end
    else begin //不是第1个好索引
      if IUpPos <> CstNotExits then begin
        TepIdx := GetIndex(IUpPos); //更新上一个索引的下一个索引位置变更
        TepIdx.MnextIdxPos := INextPos;
        ModfyIndex(TepIdx);
      end;
      if INextPos <> CstNotExits then begin //如果有下一个索引
        TepIdx := GetIndex(INextPos); //更新下一个索引的上一个索引位置变更
        TepIdx.MupIdxPos := IUpPos;
        ModfyIndex(TepIdx);
      end;
    end;
    CheckLastGoodIdx(IUpPos, ICurPos, INextPos); //处理是否是最后一个好索引的情况
  end;
  procedure CheckFirstBadIdx(IUpPos, ICurPos, INextPos: Integer); //处理坏索引
    procedure CheckLastBadIdx(ICurPos, IWillChanged: Integer); //处理是否是最后一个坏索引的情况
    begin
      if LastBadIdxPOs = ICurPos then
        LastBadIdxPOs := IWillChanged;
    end;
  begin
    if BadidxPos = CstNotExits then begin //如果是第1个坏索引
      BadidxPos := ICurPos;
      Lindex.MupIdxPos := CstNotExits;
      Lindex.MnextIdxPos := CstNotExits;
    end
    else begin //否则
      Lindex.MupIdxPos := LastBadIdxPOs;
      Lindex.MnextIdxPos := CstNotExits;
      CheckLastBadIdx(ICurPos, INextPos); //处理是否是最后一个坏索引
    end;
    //标记索引本身为坏索引
    Lindex.MisGoodIdx := False;
    ModfyIndex(Lindex);
  end;
begin
  Result := CstFine;
  Lindex := GetIndex(IIdxPos); //获取索引
  //变更好坏索引的数量
  GoodIdxCount := GoodIdxCount - 1;
  BadIdxCount := BadIdxCount + 1;
  //处理是好索引
  CheckIsFirstGoodIdx(Lindex.MupIdxPos, Lindex.MselfidxPos, Lindex.MnextIdxPos);
  //处理坏索引
  CheckFirstBadIdx(Lindex.MupIdxPos, Lindex.MselfidxPos, Lindex.MnextIdxPos);
end;

constructor TSelfFileClass.Create(Ifilename: string);
begin
  inherited Create(Ifilename);
  IndexHead := Self; //获取接口变量
end;

destructor TSelfFileClass.Destroy;
begin
  inherited;
end;

function TSelfFileClass.GetHeadIdx: RIdxHead;
begin
  with OPreater do begin
    Position := sizeof(LRhead);
    Read(Result, sizeof(RIdxHead));
  end; // with
end;

procedure TSelfFileClass.SetHeadIdx(value: RIdxHead);
begin
  with OPreater do begin
    Position := SizeOf(LRhead);
    WriteBuffer(value, sizeof(RIdxHead));
  end; // with
end;

function TSelfFileClass.getgoodidx: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MGoodIdx;
end;

procedure TSelfFileClass.SetGoodidx(value: Integer);
begin
  FIdxHead.MGoodIdx := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.Getgoodidxpos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.Mgoodidxpos;
end;

procedure TSelfFileClass.Setgoodidxpos(value: Integer);
begin
  FIdxHead.Mgoodidxpos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.GetMbadIdx: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MbadIdx;
end;

procedure TSelfFileClass.SetMbadIdx(value: Integer);
begin
  FIdxHead.MbadIdx := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.GetbadidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MbadidxPos;
end;

procedure TSelfFileClass.SetbadidxPos(value: Integer);
begin
  FIdxHead.MbadidxPos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.getLastgoodidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MlastGoodidxPos;
end;

procedure TSelfFileClass.SetLastGoodidxPos(value: Integer);
begin
  FIdxHead.MlastGoodidxPos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.getLastbadidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MLastBadIDxPos;
end;

procedure TSelfFileClass.SetLastbadidxPos(value: Integer);
begin
  FIdxHead.MLastBadIDxPos := value;
  SetHeadIdx(FIdxHead);
end;

procedure TSelfFileClass.OptimizeDataBase;
var
  Tepnum: Integer;
  Tep: Integer;
  Buff: TSelfFileClass;
  TepBuff: TMemoryStream;
  OldFIleName, TepFileName: string;
begin
  OldFIleName := FileName;
  TepFileName := 'TepComFIle';
  Buff := TSelfFileClass.Create(TepFileName);
  Buff.ZipLv := clMax;
  if GoodIdxCount = 0 then begin
    Self.Free;
    DeleteFile(OldFIleName);
    Buff.Free;
    RenameFile(TepFileName, OldFIleName);
    Exit;
  end;
  Tepnum := Goodidxpos;
  repeat
    Lindex := GetIndex(Tepnum);
    Tepnum := Lindex.MnextIdxPos;
    Tep := Lindex.MContentlen;
    LFmt := GetFmt;
    TepBuff := TMemoryStream.Create;
    TepBuff.SetSize(Tep);
    GetContent(TepBuff);
    Buff.AddItems(LFmt, TepBuff, Lindex.MIdxId);
    TepBuff.Free;
  until Tepnum = CstNotExits;
  Buff.AbsId := Self.AbsId;
  Self.Free;
  DeleteFile(OldFIleName);
  Buff.Free;
  RenameFile(TepFileName, OldFIleName);
end;

function TSelfFileClass.UpdateItem(IidxPos: Integer; IFmt: RFileContentFmt;
  var IBuff: TMemoryStream): Integer;
var
  Oldindx: Rindex;
begin
  EnCompressStream(IBuff);
  Oldindx := GetIndex(IidxPos);
  if IBuff.Size <= Oldindx.MContentlen then begin
    if IBuff.Size <> 0 then
      Oldindx.MContentlen := IBuff.Size;
    ModfyIndex(Oldindx);
    AddContentFmt(IFmt);
    AddContent(IBuff);
    Result := IidxPos;
  end
  else begin
    DeCompressStream(IBuff);
    DeleteItem(IidxPos);
    AddItems(IFmt, IBuff, Oldindx.MIdxId);
    Result := LastGoodIdxPos;
  end;
end;

function TSelfFileBassClass._AddRef: Integer;
begin
  Result := 0;
end;

function TSelfFileBassClass._Release: Integer;
begin
  Result := 0;
end;

function TSelfFileBassClass.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  Result := 0
end;

procedure TSelfFileClass.GetItemsDarray(IList: TStringList);
var
  Tep: Integer;
  LTep: TMyColocTTreemap;
begin
  Tep := Goodidxpos;
  if Tep = CstNotExits then Exit;
  repeat
    Lindex := getindex(Tep);
    Tep := Lindex.MnextIdxPos;
    LFmt := GetFmt;
    LTep := TMyColocTTreemap.Create;
    LTep.Id := IntToStr(Lindex.MIdxId);
    LTep.Mfmt := LFmt;
    LTep.MidxPos := Lindex.MselfidxPos;
    LTep.Cpt := LFmt.MCaption;
    LTep.parentid := IntToStr(LFmt.MParentId);
    IList.AddObject(LTep.Id, Ltep);
  until Tep = CstNotExits;
end;

function TSelfFileClass.GetIdxPosWithCpt(ICaption: string): Integer;
var
  tot, Llast: Integer;
begin
  Result := CstNotExits;
  tot := Goodidxpos;
  Llast := LastGoodIdxPos;
  repeat
    Lindex := GetIndex(tot);
    LFmt := GetFmt;
    tot := Lindex.MnextIdxPos;
    if LFmt.MCaption = ICaption then begin
      Result := Lindex.MselfidxPos; Break;
    end;
    if tot = Llast then Break;
    Lindex := GetIndex(Llast);
    LFmt := GetFmt;
    Llast := Lindex.MupIdxPos;
    if LFmt.MCaption = ICaption then begin
      Result := Lindex.MselfidxPos; Break;
    end;
  until Result <> CstNotExits;
end;

function TSelfFileClass.GetAbsIndx: Cardinal;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.MAbsIndxID;
end;

procedure TSelfFileClass.setABSIndx(Value: Cardinal);
begin
  FIdxHead.MAbsIndxID := value;
  SetHeadIdx(FIdxHead);
end;

end.

