unit untFileFmtDef;

interface

uses
  System.SysUtils;

type
  sFileHead = record             //�ļ�ͷ
    CreateDt: TDateTime;         //����ʱ��
    FileVer: string[10];         //��ʽ�汾
    GoTheKey: string[20];        //�ܳ�
  end;

  IndexHead = record             //����ͷ
    absIndexNum: Cardinal;       //��������ֵ
    GoodIdxTNum: Word;           //��Ч��������
    GoodIdxPos: Cardinal;        //��һ����Ч����λ��
    BadIdxTNum: Word;            //��Ч��������
    BadIdxPos: Cardinal;         //��һ����Ч����λ��
    LastGoodIdxPos: Cardinal;    //���һ����Ч������λ��
    LastBadIdxPos: Cardinal;     //���һ����Ч������λ��
  end;

  IndexBody = record
    IdxID: Cardinal;         //������
    PreIdxPos: Cardinal;     //��һ������λ��
    IsValidIdx: Boolean;     //�Ƿ���Ч
    SelfIdxPos: Cardinal;    //����λ��
    ContentPos: Cardinal;    //��������λ��
    ContentLen: Cardinal;    //���ݳ���
    NextIdxPos: Cardinal;    //��һ������λ��
  end;

  FileContentDef = record
    Kind: Byte;             //����
    ParentID: Cardinal;     //���ڵ��ʾ

    iSecNo: Integer;        //��ˮ��
    PathName: string;       //·����
    FileName: string;       //������
    PlayTime: string;       //ָ������ʱ��
    MusicLen: Integer;      //���ֳ���
    PlayTimes: Integer;     //���Ŵ���
    SingleLoop: Boolean;    //����ѭ��
    IsPlay: Boolean;        //�Ƿ񲥷�
    PlayVol: Integer;       //��������
    PLaylfRi: Integer;      //��������
    playing: Boolean;       //������
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

