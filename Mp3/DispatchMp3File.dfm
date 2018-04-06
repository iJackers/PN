object Mp3Lstfrm: TMp3Lstfrm
  Left = 439
  Top = 165
  AlphaBlend = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #21046#20316#25773#25918#21015#34920#25991#20214
  ClientHeight = 500
  ClientWidth = 515
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMp3File: TPageControl
    Left = 0
    Top = 0
    Width = 515
    Height = 452
    ActivePage = tsSpecLst
    Align = alClient
    DoubleBuffered = True
    HotTrack = True
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = True
    Style = tsFlatButtons
    TabOrder = 0
    object tsSpecLst: TTabSheet
      Caption = #23450#26102#25773#25918#21015#34920
      object lvSpecLst: TListView
        Left = 0
        Top = 0
        Width = 507
        Height = 421
        Align = alClient
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #26102#38388
            Width = 80
          end
          item
            Caption = #27468#26354#21517
            Width = 210
          end
          item
            Caption = #26102#38388#38271#24230
            Width = 110
          end
          item
            Caption = #23384#22312
          end>
        GridLines = True
        HotTrack = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tsNorLst: TTabSheet
      Caption = #38543#26426#38899#20048#21015#34920
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvNorLst: TListView
        Left = 0
        Top = 0
        Width = 507
        Height = 421
        Align = alClient
        Columns = <
          item
            Caption = #24207#21495
            Width = 60
          end
          item
            Caption = #27468#26354#21517
            Width = 270
          end
          item
            Caption = #26102#38388#38271#24230
            Width = 115
          end
          item
            Caption = #23384#22312
          end>
        GridLines = True
        HotTrack = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object pnlBtn: TPanel
    Left = 0
    Top = 452
    Width = 515
    Height = 48
    Align = alBottom
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvNone
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 1
    object btnOpenMusLst: TBitBtn
      Left = 2
      Top = 4
      Width = 83
      Height = 37
      Caption = #25171#24320#21015#34920'(&O)'
      TabOrder = 0
      OnClick = btnOpenMusLstClick
    end
    object btnAddMusFld: TBitBtn
      Left = 86
      Top = 4
      Width = 83
      Height = 37
      Caption = #28155#21152#25991#20214#22841'(&F)'
      TabOrder = 1
    end
    object btnAddMus: TBitBtn
      Left = 170
      Top = 4
      Width = 83
      Height = 37
      Caption = #28155#21152#25991#20214'(&M)'
      TabOrder = 2
    end
    object btnDeleteMus: TBitBtn
      Left = 255
      Top = 4
      Width = 83
      Height = 37
      Caption = #21024#38500#25991#20214'(&D)'
      TabOrder = 3
    end
    object btnClearMusLst: TBitBtn
      Left = 339
      Top = 4
      Width = 83
      Height = 37
      Caption = #28165#31354#21015#34920'(&C)'
      TabOrder = 4
      OnClick = btnClearMusLstClick
    end
    object btnSaveMusLst: TBitBtn
      Left = 426
      Top = 4
      Width = 83
      Height = 37
      Caption = #20445#23384#21015#34920'(&S)'
      TabOrder = 5
      OnClick = btnSaveMusLstClick
    end
  end
  object dlgOpenLst: TOpenDialog
    DefaultExt = '*.pw*'
    Filter = #25773#25918#21015#34920#25991#20214'|*.pw*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 44
    Top = 67
  end
  object dlgSaveLst: TSaveDialog
    DefaultExt = '*.pw'
    Filter = #25773#25918#21015#34920#25991#20214'|*.pw'
    InitialDir = './'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 220
    Top = 67
  end
  object actlstMenu: TActionList
    Left = 132
    Top = 67
    object actOpenLst: TAction
      Caption = 'actOpenLst'
      OnExecute = actOpenLstExecute
    end
    object actSaveLst: TAction
      Caption = 'actSaveLst'
      OnExecute = actSaveLstExecute
    end
    object actClearFileList: TAction
      Caption = 'actClearFileList'
      OnExecute = actClearFileListExecute
    end
  end
end
