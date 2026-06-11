# Ventana principal y navegacion

## MainForm

Ventana principal que se muestra tras login exitoso.

### Layout

- Panel izquierdo (`PanelLeft`): contiene `ListBoxNav` con items de navegacion
- Panel central (`PanelCenter`): area donde se embeben los frames
- `ListBoxNav` usa estilo `lbOwnerDrawFixed` para personalizar items

### Navegacion

Al hacer clic en un item del `ListBoxNav`:

1. Destruye el frame actual en `PanelCenter` (si existe)
2. Crea el frame correspondiente segun el item seleccionado
3. Configura el frame con los servicios necesarios

### Frames

| Item | Frame | Descripcion |
|------|-------|-------------|
| Inicio | `TFrame` simple con etiquetas | Bienvenida, nombre de usuario, rol, boton logout |
| Usuarios | `TFrameUserAdmin` | Lista de usuarios + formulario de creacion |
| Preferencias | `TFramePreferences` | Selector de idioma y persistencia |

### Dependencias inyectadas

```pascal
procedure Configure(ASession: TSessionService; ALoggedInUser: TUser;
  ALocalization: TLocalizationService; ALoginPreferences: ILoginPreferences;
  AUserManagement: TUserManagementService);
```

- `TSessionService` — para verificar sesion activa y cerrar sesion
- `TUser` — usuario logueado (nombre, rol)
- `TLocalizationService` — textos internacionalizados
- `ILoginPreferences` — acceso a configuracion
- `TUserManagementService` — CRUD usuarios (solo para FrameUserAdmin)
