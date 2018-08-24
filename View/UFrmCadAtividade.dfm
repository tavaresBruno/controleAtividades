object FrmCadAtividade: TFrmCadAtividade
  Left = 145
  Top = 150
  Width = 816
  Height = 505
  Caption = 'Cadastro de Atividade'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_frm: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 209
    Align = alTop
    TabOrder = 0
    DesignSize = (
      800
      209)
    object lbl_titulo: TLabel
      Left = 8
      Top = 8
      Width = 44
      Height = 16
      Caption = 'T'#237'tulo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_desc: TLabel
      Left = 8
      Top = 40
      Width = 76
      Height = 16
      Caption = 'Descri'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_tipo: TLabel
      Left = 560
      Top = 8
      Width = 37
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'Tipo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object rg_status: TRadioGroup
      Left = 8
      Top = 144
      Width = 785
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Exibir Atividades pelo Status: '
      Columns = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Todos'
        'Aberto'
        'Concluido')
      ParentFont = False
      TabOrder = 3
      OnClick = rg_statusClick
    end
    object edt_atvddTitulo: TEdit
      Left = 64
      Top = 8
      Width = 481
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 40
      TabOrder = 0
    end
    object mm_atvddDesc: TMemo
      Left = 8
      Top = 56
      Width = 785
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 150
      TabOrder = 2
    end
    object cbb_atvddTipo: TComboBox
      Left = 608
      Top = 8
      Width = 185
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object pnl_btn: TPanel
    Left = 0
    Top = 425
    Width = 800
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      800
      41)
    object btn_atvddFinalizar: TButton
      Left = 688
      Top = 8
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Finalizar Atividade'
      TabOrder = 4
      OnClick = btn_atvddFinalizarClick
    end
    object btn_atvddRemover: TButton
      Left = 489
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Remover'
      TabOrder = 2
      OnClick = btn_atvddRemoverClick
    end
    object btn_atvddGravar: TButton
      Left = 405
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Gravar'
      TabOrder = 1
      OnClick = btn_atvddGravarClick
    end
    object btn_atvddNova: TButton
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Nova'
      TabOrder = 0
      OnClick = btn_atvddNovaClick
    end
    object btn_atvddReabrir: TButton
      Left = 573
      Top = 8
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Reabrir Atividade'
      TabOrder = 3
      OnClick = btn_atvddReabrirClick
    end
  end
  object dbg_atvdd: TDBGrid
    Left = 0
    Top = 209
    Width = 800
    Height = 216
    Align = alClient
    DataSource = ds_atividade
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbg_atvddCellClick
  end
  object cds_atividade: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cds_atividadeIndex'
        Fields = 'cod'
      end>
    IndexName = 'cds_atividadeIndex'
    Params = <>
    ProviderName = 'dsp_atividade'
    StoreDefs = True
    Left = 224
    Top = 352
    object cds_atividadetitulo: TStringField
      DisplayLabel = 'T'#237'tulo'
      DisplayWidth = 40
      FieldName = 'titulo'
    end
    object cds_atividadetipo: TStringField
      DisplayLabel = 'Tipo'
      FieldName = 'tipo'
    end
    object cds_atividadedescricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      DisplayWidth = 53
      FieldName = 'descricao'
      Size = 150
    end
    object cds_atividadestatus: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'Status'
      FieldName = 'status'
      OnGetText = cds_atividadestatusGetText
    end
    object cds_atividadecod: TIntegerField
      FieldName = 'cod'
      Visible = False
    end
  end
  object ds_atividade: TDataSource
    DataSet = cds_atividade
    Left = 264
    Top = 352
  end
  object dsp_atividade: TDataSetProvider
    Left = 184
    Top = 352
  end
end
