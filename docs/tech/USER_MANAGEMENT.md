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
