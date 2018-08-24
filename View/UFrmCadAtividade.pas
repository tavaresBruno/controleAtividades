// Unidade de Visualização (View)
// Responsável por coletar as informações introduzidas pelo usuário e manipulá-las
// de acordo com a operação desejada, conectando-se à Unidade de Controle se
// necessário.

unit UFrmCadAtividade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Grids, DBGrids, DB, DBClient, ZDataset, Provider;

type
  TFrmCadAtividade = class(TForm)
    pnl_frm: TPanel;
    pnl_btn: TPanel;
    dbg_atvdd: TDBGrid;
    lbl_titulo: TLabel;
    lbl_desc: TLabel;
    lbl_tipo: TLabel;
    btn_atvddFinalizar: TButton;
    btn_atvddRemover: TButton;
    btn_atvddGravar: TButton;
    btn_atvddNova: TButton;
    rg_status: TRadioGroup;
    edt_atvddTitulo: TEdit;
    cbb_atvddTipo: TComboBox;
    mm_atvddDesc: TMemo;
    cds_atividade: TClientDataSet;
    ds_atividade: TDataSource;
    dsp_atividade: TDataSetProvider;
    cds_atividadetitulo: TStringField;
    cds_atividadetipo: TStringField;
    cds_atividadedescricao: TStringField;
    cds_atividadestatus: TIntegerField;
    cds_atividadecod: TIntegerField;
    btn_atvddReabrir: TButton;
    procedure btn_atvddNovaClick(Sender: TObject);
    procedure btn_atvddGravarClick(Sender: TObject);
    procedure btn_atvddFinalizarClick(Sender: TObject);
    procedure btn_atvddRemoverClick(Sender: TObject);
    procedure rg_statusClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cds_atividadestatusGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbg_atvddCellClick(Column: TColumn);
    procedure btn_atvddReabrirClick(Sender: TObject);
  private
    FCodAtividade : Integer;

    procedure LimpaCampos;
    procedure Carregar;
    procedure CarregaCombo;
    procedure DefineStatus( varStatus : Integer);

  public
    { Public declarations }
  end;

var
  FrmCadAtividade: TFrmCadAtividade;

implementation

uses
  UClassModel, UClassControl, Contnrs, Math;

{$R *.dfm}

// Prepara o formulário para registro de uma nova atividade
procedure TFrmCadAtividade.btn_atvddNovaClick(Sender: TObject);
begin
  LimpaCampos();
end;

// Limpa os campos da tela
procedure TFrmCadAtividade.LimpaCampos();
begin
  edt_atvddTitulo.Clear;
  cbb_atvddTipo.ItemIndex := -1;
  mm_atvddDesc.Lines.Clear;
  FCodAtividade := 0;

  if edt_atvddTitulo.CanFocus then
    edt_atvddTitulo.SetFocus;
end;

// Comunica-se com a camada de controle para passar os dados inseridos pelo
// usuário para que sejam feitas as validações de Gravação de Atividade
procedure TFrmCadAtividade.btn_atvddGravarClick(Sender: TObject);
var
  //variaveis de camada
  LcModel: TModel;
  LcControl: TControl;
begin
  LcControl := TControl.Create;
  LcModel := TModel.Create;

  try
    //atribui os valores no objeto
    LcModel.Cod := FCodAtividade;
    LcModel.Titulo := edt_atvddTitulo.Text;
    LcModel.Descricao := mm_atvddDesc.Text;

    if cbb_atvddTipo.ItemIndex = -1 then
      LcModel.CodTipo  := -1
    else
      LcModel.CodTipo  := Integer(cbb_atvddTipo.Items.Objects[cbb_atvddTipo.ItemIndex]);

    //passa os valores para a camada de controle
    LcControl.GravaAtividade(LcModel);
  finally
    //libera objetos da memória
    FreeAndNil(LcControl);
    FreeAndNil(LcModel);
  end;
  LimpaCampos;
  Carregar;
end;

// Chama procedure para definir status de finalização da atividade
procedure TFrmCadAtividade.btn_atvddFinalizarClick(Sender: TObject);
begin
  DefineStatus(1);
end;

// Comunica-se com a camada de controle para passar os dados inseridos pelo
// usuário para que sejam feitas as validações de Remoção de Atividade
procedure TFrmCadAtividade.btn_atvddRemoverClick(Sender: TObject);
var
  LcModel: TModel;
  LcControl: TControl;
begin
  LcControl := TControl.Create;
  LcModel := TModel.Create;

  try
    //Passa descrição do Tipo de Atividade para que sejam feitas validações na camada de controle
    LcControl.FDescricao := cbb_atvddTipo.Text;
    LcModel.Cod := FCodAtividade;
    if (LcControl.RemoveAtividade(LcModel)) then
    begin
      LimpaCampos;
      Carregar;
    end;
  finally
    FreeAndNil(LcControl);
    FreeAndNil(LcModel);
  end;

end;

// Filtrar as atividades de acordo com o status da ativadade
procedure TFrmCadAtividade.rg_statusClick(Sender: TObject);
begin
  if rg_status.Items[rg_status.ItemIndex] = 'Todos' then
  begin
    cds_atividade.Filtered := False;
  end
  else
  if rg_status.Items[rg_status.ItemIndex] = 'Aberto' then
  begin
    cds_atividade.Filtered := False;
    cds_atividade.Filter := 'status = 0';
    cds_atividade.Filtered := True;
  end
  else
  if rg_status.Items[rg_status.ItemIndex] = 'Concluido' then
  begin
    cds_atividade.Filtered := False;
    cds_atividade.Filter := 'status = 1';
    cds_atividade.Filtered := True;
  end;
end;

//carrega tabela de atividades
procedure TFrmCadAtividade.Carregar;
var
  LcModel: TModel;
  LcControl: TControl;
  LqQuery : TZQuery;
begin
  LcControl := TControl.Create;
  LcModel := TModel.Create;

  try
    LqQuery := LcControl.Obter(LcModel);
    try
      dsp_atividade.DataSet := LqQuery;
      cds_atividade.Close;
      cds_atividade.Open;
    finally
      FreeAndNil(LqQuery);
    end;
  finally
    FreeAndNil(LcControl);
    FreeAndNil(LcModel);
  end;
end;

// Inicializa formulário assim que este abre
procedure TFrmCadAtividade.FormShow(Sender: TObject);
begin
  FCodAtividade := 0;
  Carregar;
  CarregaCombo;
end;

//Define os Tipos da tabela do banco de dados como os itens do ComboBox
procedure TFrmCadAtividade.CarregaCombo;
var
  LcModel: TModel;
  LcControl: TControl;
  LqQuery : TZQuery;
begin
  LcControl := TControl.Create;
  LcModel := TModel.Create;

  try
    LqQuery := LcControl.ObterTipo(LcModel);
    while not LqQuery.Eof do
    begin
      //Adiciona um objeto no ComboBox para armazenamento da Descrição e do Código
      cbb_atvddTipo.Items.AddObject(LqQuery.Fields.Fields[1].AsString,
                                    TObject(LqQuery.Fields.Fields[0].AsInteger));
      LqQuery.Next;
    end;
  finally
    FreeAndNil(LqQuery);
    FreeAndNil(LcControl);
    FreeAndNil(LcModel);
  end;

end;

//Formata Status
procedure TFrmCadAtividade.cds_atividadestatusGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := EmptyStr;

  if  not Sender.IsNull then
  begin
    case Sender.AsInteger of
      0: Text := 'Em Aberto';
      1: Text := 'Finalizada';
    end;
  end;
end;


// Preenche campos do formulário com a atividade selecionada pelo usuário.
procedure TFrmCadAtividade.dbg_atvddCellClick(Column: TColumn);
begin
  FCodAtividade := cds_atividade.FieldByName('cod').AsInteger;
  edt_atvddTitulo.Text := cds_atividade.FieldByName('titulo').AsString;
  cbb_atvddTipo.ItemIndex := cbb_atvddTipo.items.IndexOf(cds_atividade.FieldByName('tipo').AsString);
  mm_atvddDesc.Text := cds_atividade.FieldByName('descricao').AsString;
end;

// Chama procedure para definir status de reabertura da atividade
procedure TFrmCadAtividade.btn_atvddReabrirClick(Sender: TObject);
begin
  DefineStatus(0);
end;

// Comunica-se com a camada de controle para passar os dados inseridos pelo
// usuário para que sejam feitas as validações conforme status.
procedure TFrmCadAtividade.DefineStatus(varStatus: Integer);
var
  LcModel: TModel;
  LcControl: TControl;
begin
  LcControl := TControl.Create;
  LcModel := TModel.Create;

  try
    LcControl.FDescricao := cbb_atvddTipo.Text;
    LcModel.Cod := FCodAtividade;
    LcModel.Titulo := edt_atvddTitulo.Text;
    LcModel.Descricao := mm_atvddDesc.Text;

    if cbb_atvddTipo.ItemIndex = -1 then
      LcModel.CodTipo  := -1
    else
      LcModel.CodTipo  := Integer(cbb_atvddTipo.Items.Objects[cbb_atvddTipo.ItemIndex]);
    LcModel.Status := varStatus;
    LcControl.DefineStatus(LcModel);
  finally
    FreeAndNil(LcControl);
    FreeAndNil(LcModel);
  end;
  LimpaCampos;
  Carregar;
end;

end.
