## 1. Core — Modelo y Repositorios

- [x] 1.1 Crear `AppCoreUser.pas` con `TUser` (id, username, passwordHash, salt, role, locked, failedAttempts)
- [x] 1.2 Crear interfaz `IUserRepository` y `TInMemoryUserRepository` en `AppCoreUserRepository.pas`
- [x] 1.3 Escribir tests para creación de usuario y repositorio in-memory (AppCoreAuthServiceTests.pas)
- [x] 1.4 Implementar `TFileUserRepository` con persistencia JSON en `AppCoreUserFileRepository.pas`

## 2. Core — Autenticación

- [x] 2.1 Escribir tests para `TAuthService` (login exitoso, credenciales inválidas, campos vacíos)
- [x] 2.2 Implementar `TAuthService` en `AppCoreAuth.pas` con validaciones
- [x] 2.3 Escribir tests para bloqueo de cuenta tras 3 intentos fallidos
- [x] 2.4 Implementar contador de intentos y bloqueo en `TAuthService`
- [x] 2.5 Escribir tests para reseteo de contador tras login exitoso
- [x] 2.6 Implementar reseteo de contador

## 3. Core — Password Hasher

- [x] 3.1 Escribir tests para `TPasswordHasher` (hash consistente, mismo hash con mismo salt, diferente con otro salt)
- [x] 3.2 Implementar `TBasicPasswordHasher` (DJB2 + salt) en `AppCoreAuth.pas`

## 4. Core — Sesión y Roles

- [x] 4.1 Crear interfaz `IClock` y `TSystemClock` en `AppCoreClock.pas`
- [x] 4.2 Escribir tests para `TSessionService` (sesión activa, expira por inactividad)
- [x] 4.3 Implementar `TSessionService` en `AppCoreAuth.pas`
- [x] 4.4 Escribir tests para `TPermissionService` (admin accede, usuario normal denegado)
- [x] 4.5 Implementar `TPermissionService` en `AppCoreAuth.pas`

## 5. Core — Preferencias de Login

- [x] 5.1 Escribir tests para recordar último usuario
- [x] 5.2 Implementar `TLoginPreferencesRepository` en `AppCorePreferences.pas`
- [x] 5.3 Integrar en `app.config` sección `[Login]`

## 6. VCL — Formulario de Login

- [x] 6.1 Crear `LoginForm.pas` y `LoginForm.dfm` con campos username/password y botón Ingresar
- [x] 6.2 Conectar el formulario con `TAuthService` para el evento de login
- [x] 6.3 Mostrar mensajes de error en el formulario
- [x] 6.4 Pre-cargar último username guardado

## 7. Integración

- [x] 7.1 Modificar `WindowsApp.dpr` para mostrar LoginForm antes que MainForm
- [x] 7.2 Pasar dependencias (repositorios, servicios) por inyección
- [x] 7.3 Agregar units nuevas al DPR de tests y de la app Windows

## 8. Limpieza

- [x] 8.1 Eliminar `AppCoreSampleService.pas` y test de muestra
- [x] 8.2 Verificar que todos los tests pasan
- [x] 8.3 Verificar que la app compila

