# Administracion de usuarios

## TUserManagementService

```pascal
constructor Create(ARepo: IUserRepository; AHasher: IPasswordHasher;
  APermission: TPermissionService);
function CreateUser(const AUsername, APassword: string; ARole: TUserRole;
  out AError: string): Boolean;
function GetUsers: TList;
function CanManage: Boolean;
```

### CreateUser

Flujo de creacion:

1. `Trim(AUsername) = ''` → error `admin_username_required`
2. `Trim(APassword) = ''` → error `admin_password_required`
3. `FRepo.FindByUsername(Trim(AUsername)) <> nil` → error `admin_username_exists`
4. Crear `TUser` con Id vacio (el repositorio asigna GUID)
5. Generar salt via `FHasher.GenerateSalt`
6. Hashear password con el salt
7. `FRepo.Save(LUser)` — el repositorio asigna Id y persiste
8. Retorna `True`

### GetUsers

- Solo si `FPermission.IsAdmin` retorna `FRepo.FindAll`
- En caso contrario retorna `nil`

### CanManage

Delega en `FPermission.IsAdmin`.

### Seguridad

- Todas las operaciones verifican permisos via `TPermissionService`
- Los strings de error usan claves de localizacion (ej. `admin_username_required`)
- El repositorio subyacente puede ser `TInMemoryUserRepository` o `TFileUserRepository`

## TFrameUserAdmin

Frame VCL embebido en la pestana Usuarios de MainForm.

### Componentes

- `LstUsers`: lista de usuarios con nombre y rol
- `EdtNewUsername`, `EdtNewPassword`: campos para nuevo usuario
- `CboNewRole`: combo de seleccion de rol (Usuario / Administrador)
- `BtnCreateUser`: boton de creacion
- `LblError`: muestra mensajes de error localizados

### Flujo de configuracion

`Configure` se llama al crear el frame y cada vez que se navega a Usuarios o cambia idioma. Por tanto:

1. Limpia `CboNewRole.Items.Clear` antes de poblar el combo
2. Agrega opciones "Usuario" y "Administrador"
3. Llama a `UpdateTexts` y `RefreshUserList`

Sin el `Clear`, los items se duplicarian cada vez que se llama a `Configure`.
