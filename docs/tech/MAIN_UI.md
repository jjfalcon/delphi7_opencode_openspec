# Ventana principal y navegacion

## MainForm

Ventana principal que se muestra tras login exitoso. No tiene variable global (`FrmMain` eliminada; se usa `LFormMain` local en `WindowsApp.dpr`).

### Layout

- Panel izquierdo (`PanelNav`): contiene `LstNav` (`TListBox`) con items de navegacion
- Panel central (`PanelCenter`): area donde se embeben los frames
- Panel superior (`PanelTop`): bienvenida, rol, boton logout

### Navegacion

Al hacer clic en un item de `LstNav`:

1. `CreateFrames` crea los frames una sola vez (lazy) y los reusa en navegaciones posteriores
2. Oculta `PanelWelcome` y el frame actual
3. Muestra el frame correspondiente segun `LstNav.ItemIndex`
4. Para Usuarios (`NAV_USUARIOS = 1`): vuelve a llamar a `Configure` para refrescar lista y combo de roles
5. Para Preferencias (`NAV_PREFERENCIAS = 2`): solo cambia visibilidad
6. El item de Usuarios se oculta si `FUserMgmt.CanManage = False`

> **Nota**: Los metodos `Configure` de los frames deben limpiar (`Clear`) los `TComboBox` antes de poblarlos. Si se llaman multiples veces (navegacion repetida a Usuarios o cambio de idioma), los items se duplicarian.

### Frames

| Item | Frame | Descripcion |
|------|-------|-------------|
| Inicio | `TFrame` simple con etiquetas | Bienvenida, nombre de usuario, rol, boton logout |
| Usuarios | `TFrameUserAdmin` | Lista de usuarios + formulario de creacion |
| Preferencias | `TFramePreferences` | Selector de idioma y persistencia |

### Dependencias inyectadas

```pascal
procedure Configure(ASession: TSessionService; AUser: TUser;
  ALocalization: TLocalizationService; ALoginPreferences: ILoginPreferences;
  AUserMgmt: TUserManagementService);
```

- `TSessionService` — para verificar sesion activa y cerrar sesion via `EndSession`
- `TUser` — usuario logueado (nombre, rol) para mostrar en bienvenida
- `TLocalizationService` — textos internacionalizados
- `ILoginPreferences` — acceso a configuracion
- `TUserManagementService` — CRUD usuarios (solo para FrameUserAdmin; `CanManage` decide si se muestra Usuarios en nav)

### Constantes de navegacion

```pascal
const
  NAV_INICIO = 0;
  NAV_USUARIOS = 1;
  NAV_PREFERENCIAS = 2;
```

Usadas en lugar de enteros literales en `LstNavClick` y `UpdateTexts`.
