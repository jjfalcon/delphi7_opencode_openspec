## 1. Refactor IUserRepository

- [x] 1.1 Se decidio mantener `TList` por compatibilidad Delphi 7 (ver design.md)
- [x] 1.2 `TInMemoryUserRepository` sin cambios (FindAll retorna TList interno)
- [x] 1.3 Tests existentes no requieren cambios (FindAll ya retorna TList)
- [x] 1.4 Auth y user-management tests siguen pasando (30 + 7 = 37 tests OK)

## 2. Factory

- [x] 2.1 Creado `AppCoreRepositoryFactory.pas` con `TRepositoryFactory`
- [x] 2.2 Tests: factory retorna memory, factory retorna file, default es memory
- [x] 2.3 Factory lee `[Repository] Type=memory|file` de `app.config`

## 3. File Repository

- [x] 3.1 Tests para `TFileUserRepository` (save, load, find, delete, persist)
- [x] 3.2 Implementado `TFileUserRepository` en `AppCoreFileUserRepository.pas`
- [x] 3.3 Integrado en `AppCoreTests.dpr`

## 4. Integracion en WindowsApp

- [x] 4.1 WindowsApp.dpr usa `TRepositoryFactory.CreateRepository`
- [x] 4.2 `TFileUserRepository` crea `data/` via `ForceDirectories`
- [x] 4.3 WindowsApp compila correctamente

## 5. Verificacion

- [x] 5.1 Todos los tests pasan: 30 auth + 5 localization + 7 user-mgmt + 9 repository = 51
- [x] 5.2 WindowsApp compila y funciona con memory repo (default)
- [x] 5.3 File repo disponible via `[Repository] Type=file` en app.config
