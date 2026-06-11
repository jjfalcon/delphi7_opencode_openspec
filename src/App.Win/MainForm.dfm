object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'SDD OpenSpec App'
  ClientHeight = 300
  ClientWidth = 600
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
  object PanelNav: TPanel
    Left = 0
    Top = 0
    Width = 150
    Height = 300
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 0
    object LstNav: TListBox
      Left = 1
      Top = 1
      Width = 148
      Height = 298
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = LstNavClick
    end
  end
  object PanelTop: TPanel
    Left = 150
    Top = 0
    Width = 450
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LblWelcome: TLabel
      Left = 15
      Top = 10
      Width = 120
      Height = 16
      Caption = 'Bienvenido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblRole: TLabel
      Left = 150
      Top = 11
      Width = 100
      Height = 13
      Caption = 'Rol'
    end
    object BtnLogout: TButton
      Left = 360
      Top = 5
      Width = 80
      Height = 25
      Caption = 'Cerrar sesi'#243'n'
      TabOrder = 0
      OnClick = BtnLogoutClick
    end
  end
  object PanelCenter: TPanel
    Left = 150
    Top = 35
    Width = 450
    Height = 265
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PanelWelcome: TPanel
      Left = 0
      Top = 0
      Width = 450
      Height = 265
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object LblWelcomeMsg: TLabel
        Left = 60
        Top = 70
        Width = 330
        Height = 30
        Alignment = taCenter
        AutoSize = False
        Caption = 'Bienvenido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblRoleMsg: TLabel
        Left = 60
        Top = 110
        Width = 330
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = 'Rol'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
