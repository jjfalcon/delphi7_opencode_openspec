## Context

MainForm actualmente tiene solo bienvenida, rol y logout. No hay navegación entre funciones. Se necesita un layout con panel izquierdo de navegación y área central para incrustar frames (Preferencias con selector de idioma, Administración de usuarios).

## Goals / Non-Goals

**Goals:**
- Panel izquierdo con TListBox de navegación: Inicio, Usuarios, Preferencias
- Panel central donde se incrustan TFrame según la opción seleccionada
- PreferencesFrame: selector de idioma (ComboBox es/en)
- UserAdminFrame: listado de usuarios + creación
- Welcome view (Inicio): bienvenida + rol en el panel central
- Frames se crean una vez y se muestran/ocultan al navegar
- Panel admin visible solo para usuarios con rol urAdmin

**Non-Goals:**
- Editar o eliminar usuarios
- Múltiples niveles de navegación
- Persistent frames state al cambiar de pestaña

## Decisions

| Decision | Option | Alternative | Reason |
|----------|--------|-------------|-------|
| Navegación | TListBox izquierdo | TPageControl, TTreeView | Simple, control total del layout |
| Contenido | TFrame por función | Panel con controles directos | Encapsulación, cada frame es una unit separada |
| User list control | TListBox + labels | TListView, TStringGrid | Minimal para MVP |
| Data source user mgmt | TUserManagementService | IUserRepository directo | Testeable, encapsula validación + hash |
| Access guard | Ocultar/mostrar item en nav según IsAdmin | Check al navegar | El item "Usuarios" no aparece para no-admin |
| Creación frames | Una vez al mostrar MainForm | Cada vez al navegar | Mejor performance, sin flicker |
| Welcome view | Labels en el panel central | TFrame separado | Suficientemente simple, sin frame extra |

## Risks / Trade-offs

- [Layout] MainForm puede saturarse con muchas funciones - mitigado con panel izquierdo extensible
- [Memory] Frames se crean al inicio y quedan en memoria - mitigado porque son livianos (solo controles VCL)
- [Security] Non-admin no debe ver ni acceder a user management - mitigado: item oculto + guard en servicio
