// Unidade de Controle (Control)
// Realiza as validações para cada operação. Em caso de falha, cria-se uma
// exceção e o processo é abortado. Em caso de sucesso, comunica-se com a camada
// de dados para realização das operações em banco dados.

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

//Validação de condições para marcar uma atividade como Finalizada.
procedure TControl.DefineStatus(const objAtividade: TModel);
begin
  //Verifica-se primeiro se o usuário selecionou uma atividade.
  if (objAtividade.Cod = 0) then
  begin
    raise Exception.Create('Selecione uma Atividade.');
  end;

  // Verifica se o usuário está finalizando ou reabrindo uma atividade
  if (objAtividade.Status = 1) then
  begin
    //Certifica-se de que o usuário digitou mais de 50 caracteres para atividades do tipo 'Atendimento' e 'Manutenção Urgente'
    if ((FDescricao = 'Atendimento') or (FDescricao = 'Manutenção Urgente')) and (Length(Trim(objAtividade.Descricao)) < 50) then
     begin
        raise Exception.Create('Para os tipos Atendimento e Manutenção Urgente, a Descrição deve conter mais de 50 caracteres para ser finalizada.');
     end;
   end;

   objAtividade.DefineStatus(objAtividade);
end;

//Validação de condições para salvar um registro no banco de dados.
procedure TControl.GravaAtividade(const objAtividade: TModel);
begin
  // Verifica-se primeiro se o usuário preencheu todos os campos da tela.
  if(Trim(objAtividade.Titulo) = EmptyStr) then
  begin
    raise Exception.Create('Preencha o Título.');
  end;

  if(objAtividade.CodTipo = -1) then
  begin
    raise Exception.Create('Escolha um Tipo.');
  end;

  if(Trim(objAtividade.Descricao) = EmptyStr) then
  begin
    raise Exception.Create('Preencha a Descrição.');
  end;

  // Verifica-se se o usuário está tentando criar ou editar uma atividade como
  // 'Manutenção Urgente' depois da data estipulada como limite (Sexta-feira 13hs)
  if ((DayOfWeek(Today) = 6) and (HourOf(Now) >= 13)) then
    raise Exception.Create('Manutenções urgentes não podem ser criadas após as 13h00min das sextas-feiras.');

  objAtividade.SalvarAtividade(objAtividade);
end;

// Comunicação com a camada de dados para obtenção das atividades e retorno destas
// para a camada de visualização.
function TControl.Obter(const objAtividade: TModel) : TZQuery;
begin
  Result := objAtividade.Obter(objAtividade);
end;

// Comunicação com a camada de dados para obtenção dos tipos de atividade e
// retorno destes para a camada de visualização.
function TControl.ObterTipo(const objAtividade: TModel): TZQuery;
begin
  Result := objAtividade.ObterTipo(objAtividade);
end;

//Validação de condições para remoção de uma atividade do banco de dados.
function TControl.RemoveAtividade(const objAtividade: TModel) : Boolean;
begin
  Result := False;
  // Verifica-se primeiro se o usuário selecionou uma atividade.
  if (objAtividade.Cod = 0) then
  begin
    raise Exception.Create('Selecione uma Atividade.');
  end;

  // Certifica-se se o usuário está tentando remover uma atividade de
  // 'Manutenção Urgente'
  if(FDescricao = 'Manutenção Urgente') then
  begin
    raise Exception.Create('Atividades de manutenção urgente não podem ser removidas, apenas finalizadas');
  end;

  //Certifica-se de que o usuário realmente deseja remover a atividade
  if (MessageDlg('Deseja remover a Atividade?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    objAtividade.RemoverAtividade(objAtividade);
    Result := True;
  end;
end;

end.
