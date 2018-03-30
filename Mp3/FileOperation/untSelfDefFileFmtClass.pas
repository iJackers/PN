unit untSelfDefFileFmtClass;

interface

uses
  untFileFmtDef, system.Classes, System.SysUtils, ZLib;

type
  TSelfDefFilebaseClass = class
  private
    fZipLevel: TCompressionLevel;      //ѹ���ȼ�;
    fFileName: string;                 //������ļ�������
    fOperater: TFileStream;            //�ڴ������
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure afterCreate; virtual;   //�����ļ���д���ļ�ͷ��ʽ
  protected
    sdFileHead: sFileHead;
    IdxHead: IndexHead;
    idxBody: IndexBody;
    SdFileContFmt: FileContentDef;
  public
    property zipLv: TCompressionLevel read fZipLevel write fZipLevel;
    property Operater: TFileStream read fOperater write fOperater;
    procedure EnCompressStream(CompressedStream: TMemoryStream);
    procedure DeCompressStream(CompressedStream: TMemoryStream);
    property FileName: string read fFileName write fFileName;
    constructor Create(iFileName: string);
    destructor Destroy; override;
  end;

type
  ItfIndexHead = interface
    function GetAbsIdx: Cardinal;
    procedure SetAbsIdx(value: Cardinal);
    function GetGoodIdx: Integer;
    procedure SetGoodIdx(value: Integer);
    function GetGoodIdxPos: Cardinal;
  end;

implementation

{ TSelfDefFilebaseClass }

procedure TSelfDefFilebaseClass.afterCreate;
begin
  with sdFileHead do
  begin
    CreateDt := now;
    FileVer := CstVer;
    GoTheKey := 'P_LOVE_X';
  end;

  with IdxHead do
  begin
    GoodIdxTNum := 0;
    GoodIdxPos := cstNotExist;
    BadIdxTNum := 0;
    BadIdxPos := cstNotExist;
    LastGoodIdxPos := cstNotExist;
    LastBadIdxPos := cstNotExist;
  end;

  with Operater do
  begin
    Position := 0;
    Write(sdFileHead, SizeOf(sdFileHead));
    Write(IdxHead, SizeOf(IdxHead));
  end;
end;

constructor TSelfDefFilebaseClass.Create(iFileName: string);
begin
  fFileName := iFileName;
  zipLv := clMax;
  if fileexists(fFileName) then
    fOperater := TFileStream.Create(fFileName, fmOpenReadWrite)
  else
  begin
    fOperater := TFileStream.Create(fFileName, fmCreate);
  end;
end;

procedure TSelfDefFilebaseClass.DeCompressStream(CompressedStream: TMemoryStream);
var
  Ds: TDecompressionStream;
  pBuffer: PChar;
  iCount: int64;
begin
  if CompressedStream.Size <= 0 then
    exit;

  CompressedStream.Position := 0;    //ָ�븴λ
  CompressedStream.ReadBuffer(iCount, SizeOf(iCount));  //��ԭʼ�ߴ�

  GetMem(pBuffer, iCount);  //�����ѹ���ڴ�ռ��С,������ת��ѹ����

  Ds := TDecompressionStream.Create(CompressedStream);  //��ѹ����
  try
    Ds.ReadBuffer(pBuffer^, iCount);  //��ѹ������ת
    CompressedStream.Clear;   //���ԭѹ������
    CompressedStream.WriteBuffer(pBuffer^, iCount); //װ���½�ѹ����
    CompressedStream.Position := 0;   //��λָ��
  finally
    FreeMem(pBuffer);  //�ͷ�GetMem������ڴ�
  end;
end;

destructor TSelfDefFilebaseClass.Destroy;
begin
  FreeAndNil(fOperater);
  inherited;
end;

procedure TSelfDefFilebaseClass.EnCompressStream(CompressedStream: TMemoryStream);
var
  SourceStream: TCompressionStream;
  DestStream: TMemoryStream;
  iCount: Int64;
begin
  if CompressedStream.Size <= 0 then
    exit;
  CompressedStream.Position := 0;      //��λָ��
  iCount := CompressedStream.Size;     //ԭʼ���ߴ�
  DestStream := TMemoryStream.Create;
  SourceStream := TCompressionStream.Create(zipLv, DestStream);
  try
    with CompressedStream do
    begin
      SaveToStream(SourceStream);
      SourceStream.Free;
      Clear;
      WriteBuffer(iCount, SizeOf(iCount));
      CopyFrom(DestStream,0);
      Position := 0;
    end;
  finally
    SourceStream.Free;
  end;

end;

function TSelfDefFilebaseClass.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := 0;
end;

function TSelfDefFilebaseClass._AddRef: Integer;
begin
  Result := 0;
end;

function TSelfDefFilebaseClass._Release: Integer;
begin
  Result := 0;
end;

end.

