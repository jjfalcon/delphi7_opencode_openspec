object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'SDD OpenSpec App'
  ClientHeight = 240
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LblWelcome: TLabel
    Left = 30
    Top = 40
    Width = 340
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblRole: TLabel
    Left = 30
    Top = 80
    Width = 340
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object BtnLogout: TButton
    Left = 160
    Top = 130
    Width = 80
    Height = 25
    Caption = 'Cerrar sesi'#243'n'
    TabOrder = 0
    OnClick = BtnLogoutClick
  end
  object LblLang: TLabel
    Left = 30
    Top = 175
    Width = 40
    Height = 13
    Caption = 'Idioma:'
  end
  object CboLang: TComboBox
    Left = 80
    Top = 172
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = CboLangChange
  end
end
