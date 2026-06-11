## Context

MainForm fue rediseniado con panel de navegacion izquierdo y contenido dinamico central mediante TFrame. Las secciones Usuarios y Preferencias ya estan implementadas y funcionales.

## Goals / Non-Goals

**Goals:**
- Formalizar las specs main, users y preferences en el workflow OpenSpec
- Documentar las decisiones de disenio ya implementadas

**Non-Goals:**
- Ningun cambio de codigo (todo ya implementado)

## Decisions

| Decision | Option | Reason |
|----------|--------|--------|
| Navegacion | TListBox izquierdo + TPanel central | Simple, sin dependencias externas |
| Contenido dinamico | TFrame embebidos con align alClient | Encapsulacion, cada feature en su propia unit |
| Users | TUserManagementService + UserAdminFrame | Testeable, separacion core/UI |
| Preferences | PreferencesFrame con evento OnLanguageChanged | Comunica cambio de idioma a MainForm |
| Persistencia idioma | app.config seccion [Language] via TIniFile | Mismo mecanismo que LoginPreferences |

## Risks / Trade-offs

- Ninguno nuevo: todo el codigo ya esta en produccion y probado
