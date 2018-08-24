// Unidade de Dados (Model)
// Monta os comandos para comunicação com banco de dados. Caso a comunicação falhe,
// cria-se uma exceção e o processo é abortado. Em caso de sucesso, informa ao
// usuário que a operação foi realizada.


unit UClassModel;

interface

uses
  Dialogs, UClassConexao, SqlExpr, ZDataset;

type
  TModel = class
  private
    FCon : TConexao;
    FCod : Integer;
    FTitulo : string;
    FCodTipo : Integer;
    FDescricao : string;
    FStatus : Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SalvarAtividade(const objAtividade: TModel);
    procedure RemoverAtividade(const objAtividade: TModel);
    procedure DefineStatus(const objAtividade: TModel);

    function Obter(const objAtividade: TModel) : TZQuery;
    function ObterTipo(const objAtividade: TModel) : TZQuery;

    property Cod : Integer read FCod write FCod;
    property Titulo : string read FTitulo write FTitulo;
    property CodTipo : Integer read FCodTipo write FCodTipo;
    property Descricao : string read FDescricao write FDescricao;
    property Status : Integer read FStatus write FStatus;
  end;

implementation

uses SysUtils;

{ TModel }

// Inicializa variáveis
constructor TModel.Create;
begin
  FCod := 0;
  FTitulo := EmptyStr;
  FCodTipo := -1;
  FDescricao := EmptyStr;
  FCon := TConexao.Create;
end;

//Destroi Conexão
destructor TModel.Destroy;
begin
  FreeAndNil(FCon);

  inherited;
end;

//Atualiza atividade, marcando-a como Finalizada
procedure TModel.DefineStatus(const objAtividade: TModel);
var
  LqQuery : TZQuery;
begin
  //Criar query
  LqQuery := FCon.CriarQuery;
  try
    //Monta comando SQL
    LqQuery.SQL.Add('UPDATE ATIVIDADE SET TITULO = :TITULO, ');
    LqQuery.SQL.Add('COD_TIPO = :COD_TIPO, ');
    LqQuery.SQL.Add('DESCRICAO = :DESCRICAO, ');
    LqQuery.SQL.Add('STATUS = :STATUS');
    LqQuery.SQL.Add('WHERE COD = :COD');
    LqQuery.ParamByName('TITULO').AsString := objAtividade.Titulo;
    LqQuery.ParamByName('COD_TIPO').AsInteger := objAtividade.CodTipo;
    LqQuery.ParamByName('DESCRICAO').AsString := objAtividade.Descricao;
    LqQuery.ParamByName('STATUS').AsInteger := objAtividade.Status;
    LqQuery.ParamByName('COD').AsInteger := objAtividade.Cod;

    //Tenta executar o comando SQL. Caso não seja possível executar, cria uma exceção e aborta o processo.
    try
      LqQuery.ExecSQL;
      MessageDlg('Status da Atividade alterado com sucesso', mtConfirmation, [mbOK], 0);
    except
      raise Exception.Create('Não foi possível realizar a operação.');
    end;
  finally
    FreeAndNil(LqQuery);
  end;
end;

//Listar todas as atividades registradas no banco de dados.
function TModel.Obter(const objAtividade: TModel): TZQuery;
var
  LqQuery : TZQuery;
begin
  LqQuery := FCon.CriarQuery;

  LqQuery.SQL.Add('SELECT A.COD, A.TITULO AS "titulo", T.DESCRICAO AS "tipo", A.DESCRICAO AS "descricao",A.STATUS AS "status" ');
  LqQuery.SQL.Add('FROM ATIVIDADE A INNER JOIN TIPO T ON A.COD_TIPO = T.COD');
  LqQuery.Open;

  Result := LqQuery;
end;

//Listar todos os Tipos registrados no banco de dados
function TModel.ObterTipo(const objAtividade: TModel): TZQuery;
var
  LqQuery : TZQuery;
begin
  LqQuery := FCon.CriarQuery;
  LqQuery.SQL.Add('SELECT * FROM TIPO');
  LqQuery.Open;
  Result := LqQuery;
end;

//Remover atividade do banco de dados
procedure TModel.RemoverAtividade(const objAtividade: TModel);
var
  LqQuery : TZQuery;
begin
  LqQuery := FCon.CriarQuery;

  try
    LqQuery.SQL.Add('DELETE FROM ATIVIDADE');
    LqQuery.SQL.Add('WHERE COD = :COD');
    LqQuery.ParamByName('COD').AsInteger := objAtividade.Cod;

    try
      LqQuery.ExecSQL;
      MessageDlg('Atividade removida com sucesso.', mtConfirmation, [mbOK], 0);
    except
      raise Exception.Create('Não foi possível realizar a operação.');
    end;
  finally
    FreeAndNil(LqQuery);
  end;
end;

//Salvar atividade no banco de dados
procedure TModel.SalvarAtividade(const objAtividade: TModel);
var
  LqQuery : TZQuery;
begin
  LqQuery := FCon.CriarQuery;

  try
    //Caso a atividade tenha um código, atualizar a atividade. Caso contrário, criar uma nova.
    if (objAtividade.Cod = 0) then
    begin
      LqQuery.SQL.Add('INSERT INTO ATIVIDADE(TITULO, COD_TIPO, DESCRICAO, STATUS) ');
      LqQuery.SQL.Add('VALUES (:TITULO, :COD_TIPO, :DESCRICAO, :STATUS)');
      LqQuery.ParamByName('TITULO').AsString := objAtividade.Titulo;
      LqQuery.ParamByName('COD_TIPO').AsInteger := objAtividade.CodTipo;
      LqQuery.ParamByName('DESCRICAO').AsString := objAtividade.Descricao;
      LqQuery.ParamByName('STATUS').AsInteger := 0;
    end
    else
    begin
      LqQuery.SQL.Add('UPDATE ATIVIDADE SET TITULO = :TITULO, ');
      LqQuery.SQL.Add('COD_TIPO = :COD_TIPO, ');
      LqQuery.SQL.Add('DESCRICAO = :DESCRICAO ');
      LqQuery.SQL.Add('WHERE COD = :COD');
      LqQuery.ParamByName('TITULO').AsString := objAtividade.Titulo;
      LqQuery.ParamByName('COD_TIPO').AsInteger := objAtividade.CodTipo;
      LqQuery.ParamByName('DESCRICAO').AsString := objAtividade.Descricao;
      LqQuery.ParamByName('COD').AsInteger := objAtividade.Cod;
    end;

    try
      LqQuery.ExecSQL;
      MessageDlg('Atividade gravada com sucesso.', mtConfirmation, [mbOK], 0);
    except
      raise Exception.Create('Não foi possível realizar a operação.');
    end;
  finally
    FreeAndNil(LqQuery);
  end;
end;

end.
