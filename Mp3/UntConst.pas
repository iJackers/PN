unit UntConst;

interface

type

 TMusicFileList = record
   iSecNo     :Integer;      //��ˮ��
   PathName   :string;       //·����
   FileName   :string;       //������
   PlayTime   :string;       //ָ������ʱ��
   MusicLen   :Integer;      //���ֳ���
   PlayTimes  :Integer;      //���Ŵ���
   SingleLoop :Boolean;      //����ѭ��
   IsPlay     :Boolean;      //�Ƿ񲥷�
   PlayVol    :Integer;      //��������
   PLaylfRi   :Integer;      //��������
   playing    :Boolean;      //������
 end;

 PMusicFileList = ^TMusicFileList;


implementation

end.
