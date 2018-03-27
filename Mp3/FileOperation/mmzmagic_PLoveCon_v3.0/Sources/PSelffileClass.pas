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
  PformatDefine, Classes, ZLib;
type
  TSelfFileBassClass = class
  private
    Fziplv: TCompressionLevel; //ѹ���ȼ�
    Ffilename: string; //������ļ�������
    FOpreater: Tfilestream; //������
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure AfterCreate; virtual; //���ļ�����������ļ�ͷ
  protected
    //���뼸��������
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
    property LastGoodIdxPos: Integer read getLastgoodidxPos write setLastgoodidxPos; //���� ���ĺ�������λ��
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos; // ���� ���Ļ�������λ��
  end;
  TSelfFileClass = class(TSelfFileBassClass, IIndexHead)
  private
    FIndexHead: IIndexHead;
    FIdxHead: RIdxHead; //������ת������ͷ��
    function GetHeadIdx: RIdxHead; //��ȡ����ͷ
    procedure SetHeadIdx(value: RIdxHead); //��������ͷ
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
    property LastGoodIdxPos: Integer read getLastgoodidxPos write setLastgoodidxPos default -1; //���� ���ĺ�������λ��
    property LastBadIdxPOs: Integer read GetLastbadidxPos write setLastbadidxPos default -1; // ���� ���Ļ�������λ��
    // �����ǵļ���
    function AddIndex(Iindex: Rindex): Byte; //�������
    function AddContentFmt(IFmt: RFileContentFmt): byte; //�������ͷ
    function AddContent(var Buff: TMemoryStream): byte; //�������
    function ModfyIndex(ReIIndex: Rindex): byte; //�޸�����
  public
    property IndexHead: IIndexHead read FIndexHead write FIndexHead;
    //����3��������һ��˳����� ����ȡ��һ������ ʹ��ʱ��Ҫ���úö�ȡλ��
    function GetIndex(Ipos: integer): Rindex; //����λ��ȡ������
    function GetFmt: RFileContentFmt; //ȡ��������ߵ�����ͷ
    function GetContent(var Buff: TMemoryStream): byte; //ȡ������
    function IsRightFile: boolean; //�ļ���ʽ�Ƿ�����ȷ
    function AddItems(IFmt: RFileContentFmt; var IBuff: TMemoryStream; const IOldAbsID: Cardinal = 0): Cardinal; //�������
    function DeleteItem(IIdxPos: Integer): byte; //����������ɾ����¼
    function UpdateItem(IidxPos: Integer; IFmt: RFileContentFmt; var IBuff: TMemoryStream): Integer; //������
    procedure OptimizeDataBase; //�Ż����ݿ�
    procedure GetItemsDarray(IList: TStringList); //��ȡԪ���б�
    function GetIdxPosWithCpt(ICaption: string): Integer; //���ݱ����õ�һ�����ڵ�λ��
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
  if (GoodIdxCount = 0) and (BadIdxCount = 0) then begin //����ǵ�1����¼��¼һ�µ�1��������λ��
    Goodidxpos := sizeof(LRhead) + sizeof(LRidx);
    Lindex.MupIdxPos := CstNotExits;
    Lindex.MisGoodIdx := True;
    Lindex.MselfidxPos := OPreater.Seek(0, soEnd);
    Lindex.MContentPos := sizeof(LRhead) + sizeof(LRidx) + sizeof(Lindex);
    Lindex.MContentlen := IBuff.Size;
    Lindex.MnextIdxPos := CstNotExits;
  end
  else begin //���ǵ�һ����¼
    Lindex.MupIdxPos := LastGoodIdxPos;
    Lindex.MisGoodIdx := True;
    Lindex.MselfidxPos := OPreater.Seek(0, soEnd);
    {20050516 add���ɾ���������Ч������}
    if Goodidxpos = CstNotExits then Goodidxpos := Lindex.MselfidxPos;
    Lindex.MContentPos := Lindex.MselfidxPos + sizeof(Lindex);
    Lindex.MContentlen := IBuff.Size;
    Lindex.MnextIdxPos := CstNotExits;
    if Lindex.MupIdxPos <> CstNotExits then begin
      TepIndex := GetIndex(Lindex.MupIdxPos); //������һ���������½�λ��
      TepIndex.MnextIdxPos := Lindex.MselfidxPos;
      ModfyIndex(TepIndex);
    end;
  end;
  LastGoodIdxPos := Lindex.MselfidxPos; //��¼���һ��������λ��
  AddIndex(lindex); //�������
  AddContentFmt(IFmt); //д������ͷ
  AddContent(IBuff); //д��������
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

////ѹ������������Ҫѹ������////

procedure TSelfFileBassClass.EnCompressStream(CompressedStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
  Count: int64; //ע�⣬�˴��޸���,ԭ����int
begin
  if CompressedStream.Size <= 0 then exit;
  CompressedStream.Position := 0;
  Count := CompressedStream.Size; //�������ԭʼ�ߴ�
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(zipLV, DM);
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
  if CompressedStream.Size <= 0 then exit;
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
  procedure CheckIsFirstGoodIdx(IUpPos, ICurPos, INextPos: Integer); //���������
    procedure CheckLastGoodIdx(IUpPos, ICurPos, IWillChanged: Integer); //�����Ƿ������һ�������������
    begin
      if LastGoodIdxPos = ICurPos then LastGoodIdxPos := IWillChanged;
      if LastGoodIdxPos = CstNotExits then LastGoodIdxPos := IUpPos;
    end;
  var
    TepIdx: Rindex;
  begin
    if ICurPos = Goodidxpos then begin //���ɾ�����ǵ�1��������
      if INextPos <> CstNotExits then begin //����һ���ͱ����һ������Ϊ��1����
        TepIdx := GetIndex(INextPos);
        TepIdx.MupIdxPos := CstNotExits;
        ModfyIndex(TepIdx);
      end;
      Goodidxpos := INextPos; //�����1�������������
    end
    else begin //���ǵ�1��������
      if IUpPos <> CstNotExits then begin
        TepIdx := GetIndex(IUpPos); //������һ����������һ������λ�ñ��
        TepIdx.MnextIdxPos := INextPos;
        ModfyIndex(TepIdx);
      end;
      if INextPos <> CstNotExits then begin //�������һ������
        TepIdx := GetIndex(INextPos); //������һ����������һ������λ�ñ��
        TepIdx.MupIdxPos := IUpPos;
        ModfyIndex(TepIdx);
      end;
    end;
    CheckLastGoodIdx(IUpPos, ICurPos, INextPos); //�����Ƿ������һ�������������
  end;
  procedure CheckFirstBadIdx(IUpPos, ICurPos, INextPos: Integer); //��������
    procedure CheckLastBadIdx(ICurPos, IWillChanged: Integer); //�����Ƿ������һ�������������
    begin
      if LastBadIdxPOs = ICurPos then
        LastBadIdxPOs := IWillChanged;
    end;
  begin
    if BadidxPos = CstNotExits then begin //����ǵ�1��������
      BadidxPos := ICurPos;
      Lindex.MupIdxPos := CstNotExits;
      Lindex.MnextIdxPos := CstNotExits;
    end
    else begin //����
      Lindex.MupIdxPos := LastBadIdxPOs;
      Lindex.MnextIdxPos := CstNotExits;
      CheckLastBadIdx(ICurPos, INextPos); //�����Ƿ������һ��������
    end;
    //�����������Ϊ������
    Lindex.MisGoodIdx := False;
    ModfyIndex(Lindex);
  end;
begin
  Result := CstFine;
  Lindex := GetIndex(IIdxPos); //��ȡ����
  //����û�����������
  GoodIdxCount := GoodIdxCount - 1;
  BadIdxCount := BadIdxCount + 1;
  //�����Ǻ�����
  CheckIsFirstGoodIdx(Lindex.MupIdxPos, Lindex.MselfidxPos, Lindex.MnextIdxPos);
  //��������
  CheckFirstBadIdx(Lindex.MupIdxPos, Lindex.MselfidxPos, Lindex.MnextIdxPos);
end;

constructor TSelfFileClass.Create(Ifilename: string);
begin
  inherited Create(Ifilename);
  IndexHead := Self; //��ȡ�ӿڱ���
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

