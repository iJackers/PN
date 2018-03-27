///////////////////////////////////////////////////////////////////////////////
//�˵�ԪΪ�����ļ��൥Ԫ                                                    //
//��������Ϊ2004��8��24��                                                  //
//��ǰ�汾��Ϊv1.0                                                        //
//������mmzmagic   QQ 22900104   ��ɶ���һ�����۹�                      //
//////////////////////////////////////////////////////////////////////////
//�Զ����ļ���������
unit PSelffileClass;

interface

uses
  PformatDefine, Classes;

type
  TSelfFileBassClass = class
  private
    Ffilename: string; //������ļ�������
    FOperater: TFileStream; //������
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure AfterCreate; virtual; //���ļ�����������ļ�ͷ
  protected
    //���뼸��������
    SdfHead: SelfDefFileHead;  //�ļ�ͷ
    IdxHead: IndexHead;        //����ͷ
    Lindex: IndexBody;        //������
    LFmt: RecContentFmt;    //���ݸ�ʽ

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
    function GetHeadIdx: IndexHead; //��ȡ����ͷ
    procedure SetHeadIdx(value: IndexHead); //��������ͷ
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
      setLastgoodidxPos; //���� ���ĺ�������λ��
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos;
      // ���� ���Ļ�������λ��
  end;

  TSelfFileClass = class(TSelfFileBassClass, IIndexHead)
  private
    FIndexHead: IIndexHead;
    FIdxHead: IndexHead; //������ת������ͷ��
    function GetHeadIdx: IndexHead; //��ȡ����ͷ
    procedure SetHeadIdx(value: IndexHead); //��������ͷ
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
      setLastgoodidxPos default -1; //���� ���ĺ�������λ��
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos
      default -1; // ���� ���Ļ�������λ��

    // function AddItems(IFmt: RFileContentFmt; var IBuff:TMemoryStream): byte; //�������
    // �����ǵļ���
    function AddIndex(Iindex: IndexBody): Byte; //�������
    function AddContentFmt(IFmt: RecContentFmt): byte; //�������ͷ
    function AddContent(var Buff: TMemoryStream): byte; //�������
    function ModfyIndex(ReIIndex: IndexBody): byte; //�޸�����
  public
    property IndexHead: IIndexHead read FIndexHead write FIndexHead;

    //����3��������һ��˳����� ����ȡ��һ������ ʹ��ʱ��Ҫ���úö�ȡλ��
    function GetIndex(Ipos: integer): IndexBody; //����λ��ȡ������
    function GetFmt: RecContentFmt; //ȡ��������ߵ�����ͷ
    function GetContent(var Buff: TMemoryStream): byte; //ȡ������

    function IsRightFile: boolean; //�ļ���ʽ�Ƿ�����ȷ
    function AddItems(IFmt: RecContentFmt; var IBuff: TMemoryStream): byte;
      overload; //�������
    function AddItems(IIdxAils: string; IFmt: RecContentFmt; var IBuff:
      TMemoryStream): byte; overload; //�������
    function DeleteItem(IIdxPos: Integer): byte; //����������ɾ����¼
    function UpdateItem(IidxPos: Integer; IFmt: RecContentFmt; var IBuff:
      TMemoryStream): Integer; overload; //
    function UpdateItem(IidxPos: Integer; IIdxAils: string; IFmt: RecContentFmt;
      var IBuff: TMemoryStream): Integer; overload; //
    procedure OptimizeDataBase; //�Ż����ݿ�
    procedure GetItemsDarray(var IDarray: DarrayList); //��ȡԪ���б�
    function GetIdxPosWithCpt(ICaption: string): Integer; //���ݱ���������
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
  //������ֵ��1
  if GoodIdxCount = 0 then
  begin //����ǵ�1����¼��¼һ�µ�1��������λ��
    Goodidxpos := Operater.Seek(0, soEnd);
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.IsGoodIdx := True;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    Lindex.CurContentlen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    LastGoodIdxPos := Lindex.CurIdxPos; //��¼���һ��������λ��
  end
  else
  begin //���ǵ�һ����¼
    Lindex.UpIdxPos := LastGoodIdxPos;
    Lindex.IsGoodIdx := True;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    LastGoodIdxPos := Lindex.CurIdxPos; //��¼���һ��������λ��
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    TepIndex := GetIndex(Lindex.UpIdxPos); //������һ���������½�λ��
    TepIndex.NextIdxPos := Lindex.CurIdxPos;
    ModfyIndex(TepIndex);
  end;
  AddIndex(lindex); //�������
  AddContentFmt(IFmt); //д������ͷ
  AddContent(IBuff); //д��������
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

////ѹ������������Ҫѹ������////

procedure TSelfFileBassClass.EnCompressStream(CompressedStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
  Count: int64; //ע�⣬�˴��޸���,ԭ����int
begin
  if CompressedStream.Size <= 0 then
    exit;
  CompressedStream.Position := 0;
  Count := CompressedStream.Size; //�������ԭʼ�ߴ�
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(clDefault, DM);
  try
    CompressedStream.SaveToStream(SM); //SourceStream�б�����ԭʼ����
    SM.Free; //��ԭʼ������ѹ����DestStream�б�����ѹ�������
    CompressedStream.Clear;
    CompressedStream.WriteBuffer(Count, SizeOf(Count)); //д��ԭʼ�ļ��ĳߴ�
    CompressedStream.CopyFrom(DM, 0); //д�뾭��ѹ������
    CompressedStream.Position := 0;
  finally
    DM.Free;
  end;
end;

////��ѹ������������Ҫ��ѹ����////

procedure TSelfFileBassClass.DeCompressStream(CompressedStream: TMemoryStream);
var
  MS: TDecompressionStream;
  Buffer: PChar;
  Count: int64;
begin
  if CompressedStream.Size <= 0 then
    exit;
  CompressedStream.Position := 0; //��λ��ָ��
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  //�ӱ�ѹ�����ļ����ж���ԭʼ�ĳߴ�
  GetMem(Buffer, Count); //���ݳߴ��СΪ��Ҫ�����ԭʼ�������ڴ��
  MS := TDecompressionStream.Create(CompressedStream);
  try
    MS.ReadBuffer(Buffer^, Count);
    //����ѹ��������ѹ����Ȼ����� Buffer�ڴ����
    CompressedStream.Clear;
    CompressedStream.WriteBuffer(Buffer^, Count); //��ԭʼ�������� MS����
    CompressedStream.Position := 0; //��λ��ָ��
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
  begin //���ɾ�����ǵ�1��������
    if Lindex.NextIdxPos = CnstNotExits then
    begin //�Ƿ�����һ������
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
  begin //���ǵ�1��������
    tep := Lindex.UpIdxPos; //ȡ����һ������
    TepN := Lindex.NextIdxPos; //ȡ����һ������
    if TepN <> CnstNotExits then
    begin //�������һ������
      Lindex := GetIndex(tep); //������һ����������һ������λ�ñ��
      Lindex.NextIdxPos := TepN;
      ModfyIndex(Lindex);
      Lindex := GetIndex(TepN);
      Lindex.UpIdxPos := tep;
      ModfyIndex(Lindex);
    end
    else
    begin //û����һ������
      Lindex := GetIndex(tep); //������һ����������һ������λ�ñ��
      Lindex.NextIdxPos := CnstNotExits;
      ModfyIndex(Lindex);
    end;
    Lindex := GetIndex(IIdxPos);
  end;
  if LastBadIdxPOs = CnstNotExits then
  begin //����ǵ�1��������
    LastBadIdxPOs := IIdxPos;
    BadidxPos := LastBadIdxPOs;
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.NextIdxPos := CnstNotExits;
  end
  else
  begin //����
    LastBadIdxPOs := Lindex.CurIdxPos; //��¼���һ��������
    Lindex.UpIdxPos := LastBadIdxPOs;
    Lindex.NextIdxPos := CnstNotExits;
  end;
  ModfyIndex(Lindex); //������������
  GoodIdxCount := GoodIdxCount - 1; //�������������
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
  //������ֵ��1
  if (GoodIdxCount = 0) and (BadIdxCount = 0) then
  begin //����ǵ�1����¼��¼һ�µ�1��������λ��
    Goodidxpos := sizeof(SdfHead) + sizeof(IdxHead);
    Lindex.UpIdxPos := CnstNotExits;
    Lindex.IsGoodIdx := True;
    Lindex.IdxAils := IIdxAils;
    Lindex.CurIdxPos := sizeof(SdfHead) + sizeof(IdxHead);
    Lindex.CurContentPos := sizeof(SdfHead) + sizeof(IdxHead) + sizeof(Lindex);
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    LastGoodIdxPos := Lindex.CurIdxPos; //��¼���һ��������λ��
  end
  else
  begin //���ǵ�һ����¼
    Lindex.UpIdxPos := LastGoodIdxPos;
    Lindex.IsGoodIdx := True;
    Lindex.IdxAils := IIdxAils;
    Lindex.CurIdxPos := Operater.Seek(0, soEnd);
    Lindex.CurContentPos := Lindex.UpIdxPos + sizeof(Lindex);
    LastGoodIdxPos := Lindex.CurIdxPos; //��¼���һ��������λ��
    Lindex.CurContentLen := IBuff.Size;
    Lindex.NextIdxPos := CnstNotExits;
    TepIndex := GetIndex(Lindex.UpIdxPos); //������һ���������½�λ��
    TepIndex.NextIdxPos := Lindex.CurIdxPos;
    ModfyIndex(TepIndex);
  end;
  AddIndex(lindex); //�������
  AddContentFmt(IFmt); //д������ͷ
  AddContent(IBuff); //д��������
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

