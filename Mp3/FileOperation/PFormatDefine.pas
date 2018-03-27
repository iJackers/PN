///////////////////////////////////////////////////////////////////////////////
//�˵�ԪΪ�����ļ���ʽ��Ԫ                                                  //
//��������Ϊ2004��8��24��                                                  //
//��ǰ�汾��Ϊv1.0                                                        //
//������mmzmagic   QQ 22900104   ��ɶ���һ�����۹�                      //
//////////////////////////////////////////////////////////////////////////
unit PFormatDefine;

interface

uses
  SysUtils;

type
  SelfDefFileHead = record //�ļ�ͷ
    CreateDT: TDateTime; //����ʱ��
    VersionStr: string[10]; //��ʽ�汾��
    GoTheKey: string[30]; //�ܳ�
  end;

  IndexHead = record //����ͷ
    GoodIdxCount: Integer; //��Ч������
    GoodFirstIdxPos: Integer; //��һ����Ч������λ��
    BadIdxCount: Integer; //��Ч������
    BadFirstIdxPos: Integer; //��һ����Ч������λ��
    LastGoodIdxPos: Integer; //���һ����Ч������λ��
    LastBadIdxPos: Integer; //���һ����Ч������λ��
  end;

  IndexBody = record //����
    UpIdxPos: integer; //��һ��������λ�� ���Ϊ-1 ��ô���ǵ�1������
    IsGoodIdx: Boolean; //�����Ƿ���Ч
    IdxAils: string[20]; //��������
    CurIdxPos: Integer; //�Լ���λ��
    CurContentPos: Integer; //��������λ��
    CurContentLen: Integer; //�����������ݳ���
    NextIdxPos: Integer; //��һ��������λ�� ���Ϊ-1 ��ô���ǵ�1������
  end;

  RecContentFmt = record //���ݸ�ʽ
    Kind: Byte; //�ƶ���ͨ
    CaptionLen: string[20]; //���ⳤ��
  end;

  GetDataList = record  //Ԫ�ؽṹ
    DataCaption: string;  //Ԫ�ر���
    DataIdxPos: Integer;  //Ԫ������λ��
  end;

type
  DarrayList = array of GetDataList;  //��̬�б� ��ȡ����Ԫ��ʹ�õ�

const
  CnstFileExt = 'pwf'; //�ļ���չ��
  CnstCurExeVer = '1.0.0.1'; //��ǰ�汾��
  CnstError = -1; //���ش���
  CnstFine = 0; // ������ȷ
  CnstNotExits = -1;

implementation

end.

