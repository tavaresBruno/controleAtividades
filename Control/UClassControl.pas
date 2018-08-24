// Unidade de Controle (Control)
// Realiza as valida��es para cada opera��o. Em caso de falha, cria-se uma
// exce��o e o processo � abortado. Em caso de sucesso, comunica-se com a camada
// de dados para realiza��o das opera��es em banco dados.

unit UClassControl;

interface

uses
  UClassModel, ZDataset;

type
  TControl = class
  private
    
  public
    FDescricao : string;

    function Obter(const objAtividade: TModel) : TZQuery;
    function ObterTipo(const objAtividade: TModel) : TZQuery;
    function RemoveAtividade(const objAtividade :  TModel) : Boolean;
    
    procedure GravaAtividade(const objAtividade :  TModel);
    procedure DefineStatus(const objAtividade :  TModel);
end;

implementation

uses
  StrUtils, SysUtils, DateUtils, Dialogs, Controls;
{ TControl }

//Valida��o de condi��es para marcar uma atividade como Finalizada.
procedure TControl.DefineStatus(const objAtividade: TModel);
begin
  //Verifica-se primeiro se o usu�rio selecionou uma atividade.
  if (objAtividade.Cod = 0) then
  begin
    raise Exception.Create('Selecione uma Atividade.');
  end;

  // Verifica se o usu�rio est� finalizando ou reabrindo uma atividade
  if (objAtividade.Status = 1) then
  begin
    //Certifica-se de que o usu�rio digitou mais de 50 caracteres para atividades do tipo 'Atendimento' e 'Manuten��o Urgente'
    if ((FDescricao = 'Atendimento') or (FDescricao = 'Manuten��o Urgente')) and (Length(Trim(objAtividade.Descricao)) < 50) then
     begin
        raise Exception.Create('Para os tipos Atendimento e Manuten��o Urgente, a Descri��o deve conter mais de 50 caracteres para ser finalizada.');
     end;
   end;

   objAtividade.DefineStatus(objAtividade);
end;

//Valida��o de condi��es para salvar um registro no banco de dados.
procedure TControl.GravaAtividade(const objAtividade: TModel);
begin
  // Verifica-se primeiro se o usu�rio preencheu todos os campos da tela.
  if(Trim(objAtividade.Titulo) = EmptyStr) then
  begin
    raise Exception.Create('Preencha o T�tulo.');
  end;

  if(objAtividade.CodTipo = -1) then
  begin
    raise Exception.Create('Escolha um Tipo.');
  end;

  if(Trim(objAtividade.Descricao) = EmptyStr) then
  begin
    raise Exception.Create('Preencha a Descri��o.');
  end;

  // Verifica-se se o usu�rio est� tentando criar ou editar uma atividade como
  // 'Manuten��o Urgente' depois da data estipulada como limite (Sexta-feira 13hs)
  if ((DayOfWeek(Today) = 6) and (HourOf(Now) >= 13)) then
    raise Exception.Create('Manuten��es urgentes n�o podem ser criadas ap�s as 13h00min das sextas-feiras.');

  objAtividade.SalvarAtividade(objAtividade);
end;

// Comunica��o com a camada de dados para obten��o das atividades e retorno destas
// para a camada de visualiza��o.
function TControl.Obter(const objAtividade: TModel) : TZQuery;
begin
  Result := objAtividade.Obter(objAtividade);
end;

// Comunica��o com a camada de dados para obten��o dos tipos de atividade e
// retorno destes para a camada de visualiza��o.
function TControl.ObterTipo(const objAtividade: TModel): TZQuery;
begin
  Result := objAtividade.ObterTipo(objAtividade);
end;

//Valida��o de condi��es para remo��o de uma atividade do banco de dados.
function TControl.RemoveAtividade(const objAtividade: TModel) : Boolean;
begin
  Result := False;
  // Verifica-se primeiro se o usu�rio selecionou uma atividade.
  if (objAtividade.Cod = 0) then
  begin
    raise Exception.Create('Selecione uma Atividade.');
  end;

  // Certifica-se se o usu�rio est� tentando remover uma atividade de
  // 'Manuten��o Urgente'
  if(FDescricao = 'Manuten��o Urgente') then
  begin
    raise Exception.Create('Atividades de manuten��o urgente n�o podem ser removidas, apenas finalizadas');
  end;

  //Certifica-se de que o usu�rio realmente deseja remover a atividade
  if (MessageDlg('Deseja remover a Atividade?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    objAtividade.RemoverAtividade(objAtividade);
    Result := True;
  end;
end;

end.
