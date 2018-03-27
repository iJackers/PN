object Form1: TForm1
  Left = 190
  Top = 105
  Caption = 'FileFormatByMyself'
  ClientHeight = 467
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 683
    Height = 448
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 0
    ExplicitHeight = 433
    object TabSheet1: TTabSheet
      Caption = 'SQl InI'
      ImageIndex = 1
      ExplicitHeight = 402
      object ListBox1: TListBox
        Left = 0
        Top = 52
        Width = 121
        Height = 313
        ImeName = #20013#25991' ('#31616#20307') - '#26234#33021' ABC'
        ItemHeight = 13
        PopupMenu = PopupMenu1
        TabOrder = 3
        OnClick = ListBox1Click
      end
      object Memo1: TMemo
        Left = 124
        Top = 128
        Width = 557
        Height = 237
        ImeName = #20013#25991' ('#31616#20307') - '#26234#33021' ABC'
        TabOrder = 6
      end
      object Button1: TButton
        Left = 230
        Top = 380
        Width = 75
        Height = 25
        Caption = #20889#20837
        TabOrder = 7
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 0
        Top = 8
        Width = 75
        Height = 25
        Caption = #25171#24320
        TabOrder = 0
        OnClick = Button2Click
      end
      object Edit1: TEdit
        Left = 123
        Top = 52
        Width = 553
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#26234#33021' ABC'
        TabOrder = 4
      end
      object RadioGroup1: TRadioGroup
        Left = 124
        Top = 76
        Width = 66
        Height = 49
        Caption = #36873#25321
        ItemIndex = 0
        Items.Strings = (
          #31227#21160
          #32852#36890)
        TabOrder = 5
      end
      object Button3: TButton
        Left = 318
        Top = 380
        Width = 75
        Height = 25
        Caption = #20462#25913
        TabOrder = 8
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 124
        Top = 8
        Width = 75
        Height = 25
        Caption = #21387#32553
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 248
        Top = 8
        Width = 137
        Height = 25
        Caption = #26681#25454#26631#39064#26597#35810#32034#24341#20301#32622
        TabOrder = 2
        OnClick = Button5Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 448
    Width = 683
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 433
  end
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 360
    object ddd1: TMenuItem
      Caption = 'Delete'
      OnClick = ddd1Click
    end
  end
end
