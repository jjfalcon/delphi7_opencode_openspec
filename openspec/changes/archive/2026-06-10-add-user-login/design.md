## Context

Aplicación Windows VCL sin autenticación actualmente. Se necesita un sistema de login con usuarios, roles y sesión. Stack: Delphi 7, VCL, test runner propio, sin paquetes externos.

## Goals / Non-Goals

**Goals:**
- Login con username/password, hash de contraseña, límite de 3 intentos fallidos, bloqueo de cuenta
- Sesión con timeout por inactividad (5 min)
- Dos roles: administrador y usuario normal
- Persistencia de usuarios en archivo JSON
- Recordar último username en archivo de configuración

**Non-Goals:**
- Registro de usuarios desde la UI (se crea admin por defecto al primer inicio)
- Recuperación de contraseña
- Autenticación contra servicios externos (LDAP, OAuth)

## Decisions

| Decisión | Opción elegida | Alternativas | Razón |
|----------|---------------|--------------|-------|
| Hash de contraseña | DJB2 con salt (TBasicPasswordHasher) | bcrypt, MD5 | Sin DLLs externas, Delphi 7 no tiene bcrypt nativo |
| Repositorio | TInMemoryUserRepository + TFileUserRepository | Solo BD | Los tests usan el in-memory; producción usa JSON |
| Sesión | TSessionService con IClock | TThread timer | Simple, testeable, sin dependencias VCL |
| Formulario login | TFrmLogin modal ShowModal | Form embebido | Flujo natural: login obligatorio antes de main |

## Risks / Trade-offs

- [Seguridad] DJB2 no es criptográficamente robusto → Mitigación: aceptable para app local sin exposición web
- [Persistencia] JSON inline parser/serializer (~180 líneas) → Mitigación: evita dependencias externas
- [Concurrencia] Sin multi-threading → Mitigación: app monousuario local no lo requiere
