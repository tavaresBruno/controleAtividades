// Unidade de Conexão
// Responsável por estabelecer e destruir a conexão com o banco de dados.

unit UClassConexao;

interface

uses
  ZLib, ZAbstractConnection, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TConexao = class
  private
    FCon: TZConnection;

    procedure ConfigurarConexao;
  public
    constructor Create;

    destructor Destroy; override;

	  function CriarQuery: TZQuery;
  end;

implementation

uses
   SysUtils, Dialogs, inifiles;

{ TConexao }

// Configura conexão de acordo com os dados encontrados no arquivo .ini
procedure TConexao.ConfigurarConexao;
var
  LfArquivoINI: TIniFile;
  LsHostName, LsDatabase, LsUser, LsPassword, LsProtocol, LsLibraryLocation, LsClientCodepage: String;
begin
  LfArquivoINI := TIniFile.Create(GetCurrentDir+'\DBConfig.ini');

  try
    LsHostName := LfArquivoINI.ReadString('Configuracoes', 'HostName', EmptyStr);
    LsDatabase := LfArquivoINI.ReadString('Configuracoes', 'Database', EmptyStr);
    LsUser := LfArquivoINI.ReadString('Configuracoes', 'User', EmptyStr);
    LsPassword := LfArquivoINI.ReadString('Configuracoes', 'Password', EmptyStr);
    LsProtocol := LfArquivoINI.ReadString('Configuracoes', 'Protocol', EmptyStr);
    LsLibraryLocation := LfArquivoINI.ReadString('Configuracoes', 'LibraryLocation', EmptyStr);
    LsClientCodepage:= LfArquivoINI.ReadString('Configuracoes', 'ClientCodepage', EmptyStr);

    with FCon do
    begin
      HostName := LsHostName;
      Database := LsDatabase;
      User := LsUser;
      Password := LsPassword;
      Protocol := LsProtocol;
      LibraryLocation := LsLibraryLocation;
      ClientCodepage := LsClientCodepage;
    end;
  finally
    FreeAndNil(LfArquivoINI);
  end;
end;

// Na construção da unidade, cria-se a conexão e a configura
constructor TConexao.Create;
begin
  FCon := TZConnection.Create(nil);

  Self.ConfigurarConexao;
end;

// Cria a query e a retorna pronta
function TConexao.CriarQuery: TZQuery;
var
  LqQuery: TZQuery;
begin
  LqQuery := TZQuery.Create(nil);
  LqQuery.Connection := FCon;
  Result := LqQuery;
end;

// Destrói a conexão
destructor TConexao.Destroy;
begin
  FreeAndNil(FCon);

  inherited;
end;

end.
