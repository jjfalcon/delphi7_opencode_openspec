object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Inicio de Sesi'#243'n'
  ClientHeight = 200
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LblUsername: TLabel
    Left = 30
    Top = 30
    Width = 40
    Height = 13
    Caption = 'Usuario:'
  end
  object LblPassword: TLabel
    Left = 30
    Top = 65
    Width = 60
    Height = 13
    Caption = 'Contrase'#241'a:'
  end
  object LblError: TLabel
    Left = 30
    Top = 155
    Width = 290
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 30
    Top = 105
    Width = 60
    Height = 13
    Caption = 'Contrase'#241'a:'
  end
  object EdtUsername: TEdit
    Left = 110
    Top = 27
    Width = 200
    Height = 21
    TabOrder = 0
  end
  object EdtPassword: TEdit
    Left = 110
    Top = 62
    Width = 200
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object BtnLogin: TButton
    Left = 110
    Top = 110
    Width = 90
    Height = 25
    Caption = 'Ingresar'
    Default = True
    TabOrder = 2
    OnClick = BtnLoginClick
  end
  object BtnCancel: TButton
    Left = 220
    Top = 110
    Width = 90
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 3
  end
end
