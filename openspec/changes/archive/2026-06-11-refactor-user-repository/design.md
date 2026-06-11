## Context

Actualmente `IUserRepository.FindAll` retorna `TList` con ownership ambiguo (el caller no sabe si debe liberar los objetos). `TFileUserRepository` nunca se implemento. No hay forma de elegir backend de persistencia.

## Goals / Non-Goals

**Goals:**
- Refactor `IUserRepository` para que `FindAll` retorne `TInterfaceList` (ownership claro via interfaz)
- Crear `TRepositoryFactory` que devuelva `IUserRepository` segun `app.config`
- Implementar `TFileUserRepository` con persistencia JSON
- Configurar repositorio desde `WindowsApp.dpr`

**Non-Goals:**
- No se implementan backends CDS, MySQL ni otros (solo se deja la arquitectura lista)
- No se cambia `TUser` ni sus propiedades

## Decisions

| Decision | Option | Reason |
|----------|--------|--------|
| FindAll return type | `TInterfaceList` | Ownership claro, Delphi 7 compatible, evita memory leaks |
| Serializacion JSON | Manual (string parsing) | Sin librerias externas, JSON plano es simple para TUser |
| Factory | `TRepositoryFactory.Create(ARepoType: string)` | Simple, sin IoC container |
| Config key | `[Repository] Type=memory\|file` | Misma convencion que `[Language]` y `[Login]` |
| Archivo por defecto | `data\users.json` relativo al .exe | Sencillo, evita rutas absolutas |

## Risks / Trade-offs

- JSON manual es verboso pero evita dependencias
- TInterfaceList requiere `System.pas` (viene con Delphi 7)
- Tests de TFileUserRepository necesitan archivos temporales
