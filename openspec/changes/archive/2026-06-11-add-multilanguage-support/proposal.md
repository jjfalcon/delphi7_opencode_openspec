## Why

La aplicación actualmente tiene todos los textos en español hardcodeados en el código. Para hacerla accesible a usuarios de otros idiomas, se necesita un sistema de internacionalización que permita cambiar el idioma sin modificar el código fuente.

## What Changes

- Nuevo servicio TLocalizationService que carga textos desde archivos INI por idioma
- Archivos de idioma: lang/es.ini (español), lang/en.ini (inglés)
- Extracción de todos los strings hardcodeados de LoginForm.pas y MainForm.pas al servicio
- Selector de idioma en el formulario de login
- Persistencia del idioma seleccionado en app.config

## Capabilities

### New Capabilities
- localization: Carga y aplicación de textos por idioma desde archivos INI

### Modified Capabilities
- user-auth: Los mensajes de error y etiquetas del login deben ser traducibles

## Impact

- Nuevo: src/App.Core/AppCoreLocalization.pas - servicio de traducción
- Nuevo: lang/es.ini - textos en español
- Nuevo: lang/en.ini - textos en inglés
- Modificado: LoginForm.pas - usar servicio en lugar de strings literales
- Modificado: MainForm.pas - usar servicio en lugar de strings literales
- Modificado: WindowsApp.dpr - inicializar servicio y pasar dependencia
- Modificado: app.config - agregar sección [Language]
- Sin paquetes externos: usa TIniFile (VCL estándar)
