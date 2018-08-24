program PrjControleAtividade;

uses
  Forms,
  UFrmCadAtividade in 'View\UFrmCadAtividade.pas' {FrmCadAtividade},
  UClassModel in 'Model\UClassModel.pas',
  UClassControl in 'Control\UClassControl.pas',
  UClassConexao in 'Model\UClassConexao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Cadastro de Atividade';
  Application.CreateForm(TFrmCadAtividade, FrmCadAtividade);
  Application.Run;
end.
