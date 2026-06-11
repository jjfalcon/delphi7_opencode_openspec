## Context

Aplicaci�n VCL Delphi 7 con textos hardcodeados en espa�ol en LoginForm y MainForm. Sin servicio de internacionalizaci�n actualmente. Stack: Delphi 7, VCL, TIniFile, sin paquetes externos.

## Goals / Non-Goals

**Goals:**
- Servicio TLocalizationService que carga textos desde archivos INI por idioma
- Archivos de idioma: lang/es.ini y lang/en.ini
- LoginForm y MainForm consumen textos desde el servicio
- LoginForm se muestra en el idioma configurado en app.config
- Selector de idioma en MainForm (usuario autenticado)
- Al cambiar idioma se persiste en app.config y se actualiza UI
- Persistencia de idioma en app.config seccion [Language]

**Non-Goals:**
- Traduccion de .dfm (los forms se construyen con textos desde codigo)
- Deteccion automatica de idioma del sistema operativo
- Soporte para mas de 2 idiomas en esta iteracion (aunque la arquitectura lo permite)
- Traduccion de mensajes de excepcion del core

## Decisions

| Decision | Opcion | Alternativa | Raz�n |
|----------|--------|-------------|-------|
| Formato archivos | INI (TIniFile) | JSON, .po, .res | TIniFile es nativo de Delphi 7, sin dependencias |
| Clave de strings | Identificador PascalCase | Texto original | Mas facil de referenciar en codigo |
| Carga de idioma | TIniFile directo | Cache en TStringList | Suficiente para pocos strings, simple |
| Selector idioma | ComboBox en MainForm | LoginForm | Usuario autenticado, no distrae del login |
| Carga idioma login | Desde app.config | Fijo es | LoginForm usa el idioma persistido |
| Default idioma | es (espanol) | Sistema operativo | La app empezo en espanol |

## Risks / Trade-offs

- [Mantenimiento] Los strings se duplican por idioma - Mitigacion: un solo archivo por idioma, facil de editar
- [Consistencia] Si falta una clave en un idioma se muestra la cadena vacia - Mitigacion: el servicio debe mostrar un mensaje de advertencia o la clave misma
- [Encoding] Delphi 7 usa ANSI, los archivos INI deben guardarse como ANSI - Mitigacion: especificar encoding ANSI al escribir archivos
