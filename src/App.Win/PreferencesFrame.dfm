object FramePreferences: TFramePreferences
  Left = 0
  Top = 0
  Width = 400
  Height = 200
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
  object LblLang: TLabel
    Left = 30
    Top = 30
    Width = 40
    Height = 13
    Caption = 'Idioma:'
  end
  object CboLang: TComboBox
    Left = 80
    Top = 27
    Width = 120
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CboLangChange
  end
  object LblPersistence: TLabel
    Left = 30
    Top = 70
    Width = 66
    Height = 13
    Caption = 'Persistencia:'
  end
  object CboPersistence: TComboBox
    Left = 120
    Top = 67
    Width = 120
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = CboPersistenceChange
  end
end
