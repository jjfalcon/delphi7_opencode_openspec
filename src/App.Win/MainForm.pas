unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  AppCoreUser, AppCoreAuth;

type
  TFrmMain = class(TForm)
    LblWelcome: TLabel;
    LblRole: TLabel;
    BtnLogout: TButton;
    procedure BtnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSession: TSessionService;
  public
    procedure Configure(ASession: TSessionService; AUser: TUser);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.Configure(ASession: TSessionService; AUser: TUser);
begin
  FSession := ASession;
  Caption := 'SDD OpenSpec App - ' + AUser.Username;
  LblWelcome.Caption := 'Bienvenido, ' + AUser.Username;
  if AUser.Role = urAdmin then
    LblRole.Caption := 'Rol: Administrador'
  else
    LblRole.Caption := 'Rol: Usuario';
end;

procedure TFrmMain.BtnLogoutClick(Sender: TObject);
begin
  FSession.EndSession;
  Close;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FSession <> nil then
    FSession.EndSession;
end;

end.
