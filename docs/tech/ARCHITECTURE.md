# Arquitectura del proyecto

## Stack

- **Lenguaje**: Delphi 7 (Object Pascal)
- **UI**: VCL Windows (Forms, Frames)
- **Pruebas**: Test runner propio en consola
- **Persistencia**: INI (config) + JSON plano (datos)
- **Sin paquetes externos**: solo VCL estandar de Delphi 7

## Estructura de capas

```
src/
  App.Core/       Reglas de negocio, interfaces, servicios
  App.Win/        Capa VCL fina, solo UI, sin logica de negocio
tests/
  App.Core.Tests/ Pruebas de consola del nucleo
```

### App.Core (nucleo)

Contiene modelos, interfaces, servicios y repositorios. No depende de VCL.

| Unidad | Responsabilidad |
|--------|----------------|
| `AppCoreUser.pas` | Clase `TUser` con `TUserRole` (admin/user) |
| `AppCoreUserRepository.pas` | Interfaz `IUserRepository` + impl. en memoria `TInMemoryUserRepository` |
| `AppCoreAuth.pas` | `TAuthService` (login), `TSessionService` (sesion/timeout), `TPermissionService` (roles), `TBasicPasswordHasher` (DJB2) |
| `AppCoreClock.pas` | `IClock` para time-testable, `TSystemClock` |
| `AppCorePreferences.pas` | `ILoginPreferences` para leer/escribir `app.config` |
| `AppCoreLocalization.pas` | `TLocalizationService` para i18n via INI |
| `AppCoreUserManagement.pas` | `TUserManagementService` (CRUD usuarios, validaciones, permisos) |
| `AppCoreFileUserRepository.pas` | `TFileUserRepository` (persistencia JSON a disco) |
| `AppCoreRepositoryFactory.pas` | `TRepositoryFactory` (Factory Method: memoria o archivo) |

### App.Win (UI)

Ventanas VCL que llaman a servicios del nucleo. Sin reglas de negocio.

| Unidad | Responsabilidad |
|--------|----------------|
| `WindowsApp.dpr` | Punto de entrada: crea dependencias, muestra LoginForm, luego MainForm |
| `LoginForm.pas` | Dialogo modal de login |
| `MainForm.pas` | Ventana principal con navegacion lateral + frames embebidos |
| `AppWinPreferencesFrame.pas` | Frame de preferencias (idioma, persistencia) |
| `AppWinUserAdminFrame.pas` | Frame de administracion de usuarios |

### Tests

Runner de consola (`AppCoreTests.dpr`) ejecuta todas las suites secuencialmente.

| Suite | Tests |
|-------|-------|
| Auth Service | 30 tests (login, session, password, permisos) |
| Localization | 5 tests (carga idiomas, fallback) |
| User Management | 7 tests (crear usuario, validaciones, permisos) |
| Repository | 9 tests (factory, file repo CRUD, persistencia) |

Total: 51 tests.

## Flujo de arranque (WindowsApp.dpr)

1. `CoInitializeEx` (COM para CoCreateGuid)
2. Crear `IUserRepository` via `TRepositoryFactory.CreateRepository(app.config)`
3. Crear `IPasswordHasher` (`TBasicPasswordHasher`)
4. Si no existe admin, crearlo con credenciales por defecto
5. Cargar idioma desde `ILoginPreferences.LoadLanguage`
6. Crear `TLocalizationService`
7. Mostrar `LoginForm` modal
8. Si login exitoso: crear `TPermissionService`, `TUserManagementService`, mostrar `MainForm`

## Build

`build.bat` compila tests y app Windows con dcc32:

```batch
dcc32 -B -U"src/App.Core" tests/App.Core.Tests/AppCoreTests.dpr
dcc32 -B -U"src/App.Core" src/App.Win/WindowsApp.dpr
```

## Convenciones

- Unit names: `AppCore<NombredelClase>.pas` (Core), `AppWin<NombredelForm>.pas` (VCL)
- Clases con prefijo `T`, interfaces con prefijo `I`
- Indentacion 2 espacios, begin/end alineados
- Metodos en PascalCase
- Atributos privados con prefijo `F`
- Properties con mismo nombre que campo privado sin prefijo
- Gestion manual de memoria: Create / Free / try-finally
- Sin genericos ni caracteristicas post-Delphi 7
- Archivos .dfm en texto (guardar con View as Text)
