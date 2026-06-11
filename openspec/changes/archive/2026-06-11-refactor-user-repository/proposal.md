## Why

Actualmente solo existe `TInMemoryUserRepository` y la task 1.4 del primer change (`TFileUserRepository`) quedo sin implementar. No hay forma de configurar el repositorio en tiempo de ejecucion ni de elegir persistencia. Se necesita una arquitectura extensible que permita conmutar entre memoria, archivo JSON, CDS, MySQL u otros sistemas sin cambiar el codigo del nucleo.

## What Changes

- Refactor `IUserRepository` como interfaz limpia (breaking: `FindAll` cambia de `TList` a `TInterfaceList` o similar para evitar memory leaks)
- Crear `TRepositoryFactory` que devuelva `IUserRepository` segun configuracion
- Implementar `TFileUserRepository` con persistencia JSON
- Refactor `TUserManagementService` para que reciba el factory (o repositorio) por inyeccion
- `WindowsApp.dpr` configura el repositorio via `app.config`

## Capabilities

### New Capabilities
- `user-repository`: Repositorio configurable con interfaz unificada y factory

### Modified Capabilities
- `user-auth`: FindAll cambia de TList a TInterfaceList (no rompe specs actuales porque tests internos se adaptan)
- `users`: La spec remain igual, solo cambios internos de implementacion

## Impact

- **BREAKING**: `IUserRepository.FindAll` retorna `TInterfaceList` en vez de `TList` (los llamadores deben actualizarse)
- `TInMemoryUserRepository` se adapta a la nueva interfaz
- `TFileUserRepository` se implementa desde cero
- `WindowsApp.dpr` necesita configuracion inicial del repositorio
- `build.bat` no cambia
- Tests existentes se actualizan pero no se eliminan
- Se aniaden tests para `TFileUserRepository`
