///////////////////////////////////////////////////////////////////////////////
//�˵�ԪΪ�����ļ���ʽ��Ԫ                                                  //
//��������Ϊ2004��8��24��                                                  //
//��ǰ�汾��Ϊv1.0                                                        //
//������mmzmagic   QQ 22900104   ��ɶ���һ�����۹�                      //
//////////////////////////////////////////////////////////////////////////
Unit PFormatDefine;

Interface

Uses SysUtils;
Type
  RFileHead = Packed Record //�ļ�ͷ
    MCreateTime: TDateTime; //����ʱ��
    MvisonNum: Shortint; //��ʽ�汾��
    MThekey: String[10]; //�ܳ�
  End;
  RIdxHead = Packed Record
    MAbsIndxID: Cardinal; //���Ե��������ֵ
    MGoodIdx: Word; //��Ч������
    Mgoodidxpos: Cardinal; //��һ����Ч������λ��
    MbadIdx: Word; //��Ч������
    MbadidxPos: Cardinal; //��һ����Ч������λ��
    MlastGoodidxPos: Cardinal; //���һ����Ч������λ��
    MLastBadIDxPos: Cardinal; //���һ����Ч������λ��
  End;
  Rindex = Packed Record //����
    MIdxId: Cardinal; //������ID��
    MupIdxPos: Cardinal; //��һ��������λ�� ���Ϊ-1 ��ô���ǵ�1������
    MisGoodIdx: Boolean; //�����Ƿ���Ч
    MselfidxPos: Cardinal; //�Լ���λ��
    MContentPos: Cardinal; //��������λ��
    MContentlen: Cardinal; //�����������ݳ���
    MnextIdxPos: Cardinal; //��һ��������λ�� ���Ϊ-1 ��ô���ǵ�1������
  End;
  RFileContentFmt = Packed Record //���ݸ�ʽ
    Mkind: Byte; //��ʾ�ļ������
    MParentId: Cardinal; //���ڵ��Ψһ��ʾ
    MCaption: String[60]; //����
    MKindStr: String[20]; //���
  End;
Const
  CimgIdxDir = 1; //3�ֽڵ�����
  CimgIdxFile = 2;
  CimgIdxIE = 3;
  CstFileName = 'DB'; //�ļ���
  CstExt = '.mmz'; //�ļ���չ��
  CstCurrvon = 1; //��ǰ�汾��
  CstError = 0; //���ش���
  CstFine = 1; // ������ȷ
  CstNotExits = 0; //������

Implementation

End.
