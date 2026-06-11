# Design: Fix combos duplicados

## Causa raiz

`TFrameUserAdmin.Configure` y `TFramePreferences.Configure` se llaman multiples
veces (navegacion a Usuarios, cambio de idioma via `OnLanguageChanged`) y añadian
items a los `TComboBox.Items` sin limpiar.

`TMainForm.LstNavClick` llama a `FrameUserAdmin.Configure` en cada clic a Usuarios
(linea 168 de MainForm.pas). `OnLanguageChanged` tambien llama a `Configure`.
Ambos metodos usaban `Items.Add` directo.

## Cambio

Agregar `Items.Clear` inmediatamente antes de los `Items.Add` en ambos metodos
`Configure`. Esto asegura idempotencia: multiples llamadas no acumulan items.

## Verificacion

- Compila (build.bat)
- 51 tests pasan
- No hay cambio de comportamiento funcional
