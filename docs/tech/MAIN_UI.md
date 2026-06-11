# Ventana principal y navegacion

## MainForm

Ventana principal que se muestra tras login exitoso.

### Layout

- Panel izquierdo (`PanelLeft`): contiene `ListBoxNav` con items de navegacion
- Panel central (`PanelCenter`): area donde se embeben los frames
- `ListBoxNav` usa estilo `lbOwnerDrawFixed` para personalizar items

### Navegacion

Al hacer clic en un item del `ListBoxNav`:

1. `CreateFrames` crea los frames una sola vez (lazy) y los reusa en navegaciones posteriores
2. Oculta el frame actual y muestra el correspondiente
3. Para el frame de Usuarios, vuelve a llamar a `Configure` para refrescar lista y combo de roles
4. Para Preferencias, solo cambia visibilidad (no se reconfigura)

> **Nota**: Los metodos `Configure` de los frames deben limpiar (`Clear`) los `TComboBox` antes de poblarlos. Si se llaman multiples veces (navegacion repetida a Usuarios o cambio de idioma), los items se duplicarian.

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
