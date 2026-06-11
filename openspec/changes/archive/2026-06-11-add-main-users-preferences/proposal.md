## Why

La aplicacion ya implementa navegacion lateral, administracion de usuarios y preferencias de idioma, pero no tiene un cambio formal que documente estas capacidades. Este change formaliza las specs existentes.

## What Changes

- Nueva spec `main`: panel de navegacion izquierdo, vista de bienvenida, cierre de sesion
- Nueva spec `users`: listado y creacion de usuarios (admin only) con validaciones
- Nueva spec `preferences`: selector de idioma con persistencia y actualizacion en tiempo real

## Capabilities

### New Capabilities
- `main`: Pantalla principal con navegacion lateral y contenido dinamico
- `users`: Administracion de usuarios (admin only)
- `preferences`: Preferencias de idioma

### Modified Capabilities

(Ninguna - todas son capacidades nuevas)

## Impact

- Las specs ya existen en `openspec/specs/` como implementadas
- No hay cambios de codigo pendientes
- Este change solo formaliza el registro en el workflow OpenSpec
