object FrameUserAdmin: TFrameUserAdmin
  Left = 0
  Top = 0
  Width = 450
  Height = 250
  VertScrollBar.Visible = False
  HorzScrollBar.Visible = False
  Align = alClient
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object LblTitle: TLabel
    Left = 20
    Top = 15
    Width = 120
    Height = 16
    Caption = 'Administrar Usuarios'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
    object LstUsers: TListBox
      Left = 20
      Top = 40
      Width = 200
      Height = 180
      ItemHeight = 13
      TabOrder = 0
      OnClick = LstUsersClick
    end
  object GrpCreate: TGroupBox
    Left = 235
    Top = 35
    Width = 200
    Height = 185
    Caption = 'Crear Usuario'
    TabOrder = 1
    object LblNewUsername: TLabel
      Left = 10
      Top = 20
      Width = 50
      Height = 13
      Caption = 'Usuario:'
    end
    object EdtNewUsername: TEdit
      Left = 10
      Top = 35
      Width = 175
      Height = 21
      TabOrder = 0
    end
    object LblNewPassword: TLabel
      Left = 10
      Top = 65
      Width = 65
      Height = 13
      Caption = 'Contrase'#241'a:'
    end
    object EdtNewPassword: TEdit
      Left = 10
      Top = 80
      Width = 175
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object LblNewRole: TLabel
      Left = 10
      Top = 110
      Width = 23
      Height = 13
      Caption = 'Rol:'
    end
    object CboNewRole: TComboBox
      Left = 10
      Top = 125
      Width = 175
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object BtnCreateUser: TButton
      Left = 55
      Top = 152
      Width = 90
      Height = 25
      Caption = 'Crear'
      TabOrder = 3
      OnClick = BtnCreateUserClick
    end
  end
  object BtnEditUser: TButton
    Left = 20
    Top = 222
    Width = 90
    Height = 25
    Caption = 'Editar'
    Enabled = False
    TabOrder = 2
    OnClick = BtnEditUserClick
  end
  object BtnDeleteUser: TButton
    Left = 120
    Top = 222
    Width = 90
    Height = 25
    Caption = 'Eliminar'
    Enabled = False
    TabOrder = 3
    OnClick = BtnDeleteUserClick
  end
  object LblError: TLabel
    Left = 20
    Top = 225
    Width = 410
    Height = 15
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
end
