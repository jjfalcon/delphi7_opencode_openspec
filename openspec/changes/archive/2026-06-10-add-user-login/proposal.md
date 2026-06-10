## Why

La aplicación Windows necesita un sistema de autenticación para restringir el acceso a usuarios autorizados, diferenciando roles de administrador y usuario normal. Sin login, cualquier persona puede ejecutar la aplicación sin control.

## What Changes

- Nuevo modelo `TUser` con id, username, password hasheado, rol y estado (activo/bloqueado)
- Servicio `TAuthService` para login con validaciones, límite de intentos fallidos y bloqueo
- Servicio `TSessionService` para mantener sesión activa con timeout por inactividad
- Servicio `TPasswordHasher` para hash seguro de contraseñas
- Servicio `TPermissionService` para control de acceso por rol
- Formulario VCL `LoginForm` como diálogo modal de ingreso
- Persistencia de usuarios en archivo JSON
- Recordar último nombre de usuario usado

## Capabilities

### New Capabilities
- `user-auth`: Autenticación de usuarios con username/password, control de intentos, bloqueo y sesión con timeout
- `user-admin`: Gestión de usuarios (CRUD) solo para rol administrador

### Modified Capabilities
<!-- No existing specs yet, this is the first feature -->

## Impact

- Nuevas units en `src/App.Core`: `AppCoreUser`, `AppCoreAuth`, `AppCoreClock`
- Nuevo form VCL: `src/App.Win/LoginForm.pas` + `LoginForm.dfm`
- Nuevas units de test: `tests/App.Core.Tests/AppCoreAuthServiceTests.pas`
- El `WindowsApp.dpr` debe modificarse para integrar el flujo de login
