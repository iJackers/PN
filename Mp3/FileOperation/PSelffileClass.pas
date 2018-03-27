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
  PformatDefine, Classes;

type
  TSelfFileBassClass = class
  private
    Ffilename: string; //保存的文件名属性
    FOperater: TFileStream; //操作流
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure AfterCreate; virtual; //新文件创建后加入文件头
  protected
    //申请几个缓冲区
    SdfHead: SelfDefFileHead;  //文件头
    IdxHead: IndexHead;        //索引头
    Lindex: IndexBody;        //索引体
    LFmt: RecContentFmt;    //内容格式

    procedure EnCompressStream(CompressedStream: TMemoryStream);
    procedure DeCompressStream(CompressedStream: TMemoryStream);
    property Operater: TFileStream read FOperater write FOperater;
  public
    property FileName: string read FFileName write FFileName;
    constructor Create(Ifilename: string);
    destructor Destroy; override;
  end;

type
  IIndexHead = interface
    function GetHeadIdx: IndexHead; //获取索引头
    procedure SetHeadIdx(value: IndexHead); //更新索引头
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
    property LastGoodIdxPos: Integer read getLastgoodidxPos write
      setLastgoodidxPos; //属性 最后的好索引的位置
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos;
      // 属性 最后的坏索引的位置
  end;

  TSelfFileClass = class(TSelfFileBassClass, IIndexHead)
  private
    FIndexHead: IIndexHead;
    FIdxHead: IndexHead; //用来中转保索引头性
    function GetHeadIdx: IndexHead; //获取索引头
    procedure SetHeadIdx(value: IndexHead); //更新索引头
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
    property GoodIdxCount: Integer read getgoodidx write SetGoodidx default 0;
    property Goodidxpos: Integer read Getgoodidxpos write Setgoodidxpos default
      CnstNotExits;
    property BadIdxCount: Integer read GetMbadIdx write SetMbadIdx default 0;
    property BadidxPos: Integer read GetbadidxPos write SetbadidxPos default CnstNotExits;
    property LastGoodIdxPos: Integer read getLastgoodidxPos write
      setLastgoodidxPos default -1; //属性 最后的好索引的位置
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos
      default -1; // 属性 最后的坏索引的位置

    // function AddItems(IFmt: RFileContentFmt; var IBuff:TMemoryStream): byte; //添加子项
    // 是它们的集合
    function AddIndex(Iindex: IndexBody): Byte; //添加索引
    function AddContentFmt(IFmt: RecContentFmt): byte; //添加内容头
    function AddContent(var Buff: TMemoryStream): byte; //添加内容
    function ModfyIndex(ReIIndex: IndexBody): byte; //修改索引
  public
    property IndexHead: IIndexHead read FIndexHead write FIndexHead;

    //下面3个函数是一组顺序操作 可以取出一条数据 使用时先要设置好读取位置
    function GetIndex(Ipos: integer): IndexBody; //根据位置取得索引
    function GetFmt: RecContentFmt; //取得索引后边的内容头
    function GetContent(var Buff: TMemoryStream): byte; //取得内容

    function IsRightFile: boolean; //文件格式是否是正确
    function AddItems(IFmt: RecContentFmt; var IBuff: TMemoryStream): byte;
      overload; //添加子项
    function AddItems(IIdxAils: string; IFmt: RecContentFmt; var IBuff:
      TMemoryStream): byte; overload; //添加子项
    function DeleteItem(IIdxPos: Integer): byte; //根据索引号删除记录
    function UpdateItem(IidxPos: Integer; IFmt: RecContentFmt; var IBuff:
      TMemoryStream): Integer; overload; //
    function UpdateItem(IidxPos: Integer; IIdxAils: string; IFmt: RecContentFmt;
      var IBuff: TMemoryStream): Integer; overload; //
    procedure OptimizeDataBase; //优化数据库
    procedure GetItemsDarray(var IDarray: DarrayList); //获取元素列表
    function GetIdxPosWithCpt(ICaption: string): Integer; //根据标题获得内容
    constructor Create(iFilename: string);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, ZLib;

{ TSelfFileClass }

function TSelfFileClass.AddContent(var Buff: TMemoryStream): byte;
begin
  Result := CnstFine;
  with Operater do
  begin
    Write(Buff.memory^, Buff.Size);
  end; // with
end;

function TSelfFileClass.AddContentFmt(IFmt: RecContentFmt): byte;
begin
  Result := CnstFine;
  with Operater do
  begin
    Write(IFmt, sizeof(IFmt));
  end; // with
end;

function TSelfFileClass.AddIndex(Iindex: IndexBody): byte;
begin
  Result := CnstFine;
  with Operater do
  begin
    Position := LastGoodIdxPos;
    Write(Iindex, sizeof(Iindex));
  end; // with
end;

function TSelfFileClass.AddItems(IFmt: RecContentFmt; var IBuff: TMemoryStream): byte;
var
  TepIndex: IndexBody;
begin
  EnCompressStream(IBuff);
  Result := CnstFine;
  //将索引值加1
  if GoodIdxCount = 0 then
  begin //如果是第1条记录纪录一下第1个索引的位置
    Goodidxpos := Operater.Seek(0, soEnd);
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.IsGoodIdx := True;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    Lindex.CurContentlen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    LastGoodIdxPos := Lindex.CurIdxPos; //记录最后一个索引的位置
  end
  else
  begin //不是第一条记录
    Lindex.UpIdxPos := LastGoodIdxPos;
    Lindex.IsGoodIdx := True;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    LastGoodIdxPos := Lindex.CurIdxPos; //记录最后一个索引的位置
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    TepIndex := GetIndex(Lindex.UpIdxPos); //更新上一个索引的下接位置
    TepIndex.NextIdxPos := Lindex.CurIdxPos;
    ModfyIndex(TepIndex);
  end;
  AddIndex(lindex); //添加索引
  AddContentFmt(IFmt); //写入内容头
  AddContent(IBuff); //写入内容体
  GoodIdxCount := GoodIdxCount + 1;
end;

procedure TSelfFileBassClass.AfterCreate;
begin
  SdfHead.CreateDT := now;
  SdfHead.VersionStr := CnstCurExeVer;
  SdfHead.GoTheKey := 'P_Love_X';
  IdxHead.GoodIdxCount := 0;
  IdxHead.GoodFirstIdxPos := CnstNotExits;
  IdxHead.BadIdxCount := 0;
  IdxHead.BadFirstIdxPos := CnstNotExits;
  IdxHead.LastGoodIdxPos := CnstNotExits;
  IdxHead.LastBadIdxPos := CnstNotExits;
  with Operater do
  begin
    Position := 0;
    Write(SdfHead, sizeof(SdfHead));
    Write(IdxHead, Sizeof(IdxHead));
  end;
end;

constructor TSelfFileBassClass.Create(iFileName: string);
begin
  fFileName := iFileName;
  if FileExists(iFileName) then
    FOperater := TFileStream.Create(iFileName, fmOpenReadWrite)
  else
  begin
    FOperater := TFileStream.Create(iFileName, fmCreate);
    afterCreate;
  end;
end;

destructor TSelfFileBassClass.Destroy;
begin
  FreeAndNil(FOperater);
  inherited;
end;

////压缩流，参数：要压缩的流////

procedure TSelfFileBassClass.EnCompressStream(CompressedStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
  Count: int64; //注意，此处修改了,原来是int
begin
  if CompressedStream.Size <= 0 then
    exit;
  CompressedStream.Position := 0;
  Count := CompressedStream.Size; //获得流的原始尺寸
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(clDefault, DM);
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
  if CompressedStream.Size <= 0 then
    exit;
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
  Result := CnstFine;
  with Operater do
  begin
    Read(Buff.memory^, Buff.Size);
    DeCompressStream(Buff);
  end; // with
end;

function TSelfFileClass.GetFmt: RecContentFmt;
begin
  with Operater do
  begin
    Read(Result, sizeof(Result));
  end; // with
end;

function TSelfFileClass.GetIndex(Ipos: integer): IndexBody;
begin
  with Operater do
  begin
    Position := Ipos;
    ReadBuffer(Result, sizeof(Result));
  end; // with
end;

function TSelfFileClass.IsRightFile: boolean;
begin
  Result := True;
  with Operater do
  begin
    Position := 0;
    Read(SdfHead, sizeof(SdfHead));
    if SdfHead.GoTheKey <> 'P_LOVE_X' then
      Result := False;
  end; // with
end;

function TSelfFileClass.ModfyIndex(ReIIndex: IndexBody): byte;
begin
  Result := CnstFine;
  with Operater do
  begin
    Position := ReIIndex.CurIdxPos;
    WriteBuffer(ReIIndex, sizeof(ReIIndex));
  end; // with
end;

function TSelfFileClass.DeleteItem(IIdxPos: Integer): byte;
var
  TepN: Integer;
  tep: Integer;
begin
  Result := CnstFine;
  Lindex := GetIndex(IIdxPos);
  Lindex.IsGoodIdx := False;
  if Lindex.CurIdxPos = Goodidxpos then
  begin //如果删除的是第1个好索引
    if Lindex.NextIdxPos = CnstNotExits then
    begin //是否有下一个索引
      Goodidxpos := CnstNotExits;
      LastGoodIdxPos := CnstNotExits;
    end
    else
    begin
      Lindex := GetIndex(Lindex.NextIdxPos);
      Lindex.UpIdxPos := CnstNotExits;
      Goodidxpos := Lindex.CurIdxPos;
    end;
    ModfyIndex(Lindex);
    Lindex := GetIndex(IIdxPos);
  end
  else
  begin //不是第1个好索引
    tep := Lindex.UpIdxPos; //取得上一个索引
    TepN := Lindex.NextIdxPos; //取得下一个索引
    if TepN <> CnstNotExits then
    begin //如果有下一个索引
      Lindex := GetIndex(tep); //更新上一个索引的下一个索引位置变更
      Lindex.NextIdxPos := TepN;
      ModfyIndex(Lindex);
      Lindex := GetIndex(TepN);
      Lindex.UpIdxPos := tep;
      ModfyIndex(Lindex);
    end
    else
    begin //没有下一个索引
      Lindex := GetIndex(tep); //更新上一个索引的下一个索引位置变更
      Lindex.NextIdxPos := CnstNotExits;
      ModfyIndex(Lindex);
    end;
    Lindex := GetIndex(IIdxPos);
  end;
  if LastBadIdxPOs = CnstNotExits then
  begin //如果是第1个坏索引
    LastBadIdxPOs := IIdxPos;
    BadidxPos := LastBadIdxPOs;
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.NextIdxPos := CnstNotExits;
  end
  else
  begin //否则
    LastBadIdxPOs := Lindex.CurIdxPos; //纪录最后一个坏索引
    Lindex.UpIdxPos := LastBadIdxPOs;
    Lindex.NextIdxPos := CnstNotExits;
  end;
  ModfyIndex(Lindex); //更新索引本身
  GoodIdxCount := GoodIdxCount - 1; //将索引数量变更
  BadIdxCount := BadIdxCount + 1;
end;

constructor TSelfFileClass.Create(iFileName: string);
begin
  inherited Create(iFileName);
  IndexHead := Self;
end;

destructor TSelfFileClass.Destroy;
begin
  inherited;
end;

function TSelfFileClass.GetHeadIdx: IndexHead;
begin
  with Operater do
  begin
    Position := sizeof(SdfHead);
    Read(Result, sizeof(IndexHead));
  end; // with
end;

procedure TSelfFileClass.SetHeadIdx(value: IndexHead);
begin
  with Operater do
  begin
    Position := SizeOf(SdfHead);
    WriteBuffer(value, sizeof(IndexHead));
  end; // with
end;

function TSelfFileClass.getgoodidx: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.GoodIdxCount;
end;

procedure TSelfFileClass.SetGoodidx(value: Integer);
begin
  FIdxHead.GoodIdxCount := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.Getgoodidxpos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.GoodFirstIdxPos;
end;

procedure TSelfFileClass.Setgoodidxpos(value: Integer);
begin
  FIdxHead.GoodFirstIdxPos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.GetMbadIdx: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.BadIdxCount;
end;

procedure TSelfFileClass.SetMbadIdx(value: Integer);
begin
  FIdxHead.BadIdxCount := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.GetbadidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.BadFirstIdxPos;
end;

procedure TSelfFileClass.SetbadidxPos(value: Integer);
begin
  FIdxHead.BadFirstIdxPos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.getLastgoodidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.LastGoodIdxPos;
end;

procedure TSelfFileClass.SetLastGoodidxPos(value: Integer);
begin
  FIdxHead.LastGoodIdxPos := value;
  SetHeadIdx(FIdxHead);
end;

function TSelfFileClass.getLastbadidxPos: Integer;
begin
  FIdxHead := GetHeadIdx;
  Result := FIdxHead.LastBadIdxPos;
end;

procedure TSelfFileClass.SetLastbadidxPos(value: Integer);
begin
  FIdxHead.LastBadIdxPos := value;
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
  if GoodIdxCount = 0 then
  begin
    Self.Free;
    DeleteFile(OldFIleName);
    Buff.Free;
    RenameFile(TepFileName, OldFIleName);
    Exit;
  end;
  Tepnum := Goodidxpos;
  repeat
    Lindex := GetIndex(Tepnum);
    Tepnum := Lindex.NextIdxPos;
    if Lindex.IsGoodIdx then
    begin
      Tep := Lindex.CurContentLen;
      LFmt := GetFmt;
      TepBuff := TMemoryStream.Create;
      TepBuff.SetSize(Tep);
      GetContent(TepBuff);
      Buff.AddItems(LFmt, TepBuff);
      TepBuff.Free;
    end;
  until Tepnum = CnstNotExits;
  Self.Free;
  DeleteFile(OldFIleName);
  Buff.Free;
  RenameFile(TepFileName, OldFIleName);
end;

function TSelfFileClass.AddItems(IIdxAils: string; IFmt: RecContentFmt; var
  IBuff: TMemoryStream): byte;
var
  TepIndex: IndexBody;
begin
  EnCompressStream(IBuff);
  Result := CnstFine;
  //将索引值加1
  if (GoodIdxCount = 0) and (BadIdxCount = 0) then
  begin //如果是第1条记录纪录一下第1个索引的位置
    Goodidxpos := sizeof(SdfHead) + sizeof(IdxHead);
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.IsGoodIdx := True;
    Lindex.IdxAils := IIdxAils;
    Lindex.CurIdxPos := sizeof(SdfHead) + sizeof(IdxHead);
    Lindex.CurContentPos := sizeof(SdfHead) + sizeof(IdxHead) + sizeof(Lindex);
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    LastGoodIdxPos := Lindex.CurIdxPos; //记录最后一个索引的位置
  end
  else
  begin //不是第一条记录
    Lindex.UpIdxPos := LastGoodIdxPos;
    Lindex.IsGoodIdx := True;
    Lindex.IdxAils := IIdxAils;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    LastGoodIdxPos := Lindex.CurIdxPos; //记录最后一个索引的位置
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    TepIndex := GetIndex(Lindex.UpIdxPos); //更新上一个索引的下接位置
    TepIndex.NextIdxPos := Lindex.CurIdxPos;
    ModfyIndex(TepIndex);
  end;
  AddIndex(lindex); //添加索引
  AddContentFmt(IFmt); //写入内容头
  AddContent(IBuff); //写入内容体
  GoodIdxCount := GoodIdxCount + 1;
end;

function TSelfFileClass.UpdateItem(IidxPos: Integer; IFmt: RecContentFmt; var
  IBuff: TMemoryStream): Integer;
var
  Oldindx: IndexBody;
begin
  EnCompressStream(IBuff);
  Oldindx := GetIndex(IidxPos);
  if IBuff.Size <= Oldindx.CurContentLen then
  begin
    Oldindx.CurContentLen := IBuff.Size;
    ModfyIndex(Oldindx);
    AddContentFmt(IFmt);
    AddContent(IBuff);
    Result := IidxPos;
  end
  else
  begin
    DeCompressStream(IBuff);
    Oldindx := GetIndex(IidxPos);
    DeleteItem(IidxPos);
    AddItems(IFmt, IBuff);
    Result := LastGoodIdxPos;
  end;
end;

function TSelfFileClass.UpdateItem(IidxPos: Integer; IIdxAils: string; IFmt:
  RecContentFmt; var IBuff: TMemoryStream): Integer;
var
  Oldindx: IndexBody;
begin
  Oldindx := GetIndex(IidxPos);
  DeleteItem(IidxPos);
  AddItems(IIdxAils, IFmt, IBuff);
  Result := LastGoodIdxPos;
end;

function TSelfFileBassClass._AddRef: Integer;
begin
  Result := 0;
end;

function TSelfFileBassClass._Release: Integer;
begin
  Result := 0;
end;

function TSelfFileBassClass.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TSelfFileClass.GetItemsDarray(var IDarray: DarrayList);
var
  Tot, Tep: Integer;
begin
  Tot := GoodIdxCount;
  SetLength(IDarray, Tot);
  Tot := 0;
  Tep := Goodidxpos;
  repeat
    Lindex := getindex(Tep);
    Tep := Lindex.NextIdxPos;
    LFmt := GetFmt;
    IDarray[Tot].DataCaption := LFmt.Captionlen;
    IDarray[Tot].DataIdxPos := Lindex.CurIdxPos;
    inc(Tot);
  until Tep = CnstNotExits;
end;

function TSelfFileClass.GetIdxPosWithCpt(ICaption: string): Integer;
var
  tot, Llast: Integer;
  ISfound: boolean;
begin
  Result := CnstNotExits;
  tot := Goodidxpos;
  Llast := LastGoodIdxPos;
  ISfound := False;
  repeat
    Lindex := GetIndex(tot);
    LFmt := GetFmt;
    tot := Lindex.NextIdxPos;
    if LFmt.Captionlen = ICaption then
    begin
      ISfound := True;
      Result := Lindex.CurIdxPos;
      Break;
    end;
    Lindex := GetIndex(Llast);
    LFmt := GetFmt;
    Llast := Lindex.UpIdxPos;
    if LFmt.Captionlen = ICaption then
    begin
      ISfound := True;
      Result := Lindex.CurIdxPos;
      Break;
    end;
  until ISfound;
end;

end.

