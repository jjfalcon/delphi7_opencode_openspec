# Fix: Combos duplicados en frames de Usuarios y Preferencias

## Problema

Al navegar a la pestaña Usuarios o cambiar de idioma, los items de los `TComboBox`
(CboNewRole en UserAdmin, CboLang y CboPersistence en Preferencias) se duplicaban
porque `Configure` añadia items sin limpiar el contenido previo.

## Solucion

Agregar `Items.Clear` antes de poblar los combos en ambos frames.

## Archivos modificados

- `src/App.Win/AppWinUserAdminFrame.pas` — `CboNewRole.Items.Clear`
- `src/App.Win/AppWinPreferencesFrame.pas` — `CboLang.Items.Clear` y `CboPersistence.Items.Clear`

## Documentacion actualizada

- `docs/tech/MAIN_UI.md` — ciclo de vida real de frames + nota del Clear
- `docs/tech/PREFERENCES.md` — paso Clear en flujo de carga
- `docs/tech/USER_MANAGEMENT.md` — seccion TFrameUserAdmin con flujo de configuracion
