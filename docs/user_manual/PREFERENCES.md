# Manual de Usuario - Preferencias

## 1. Acceso

Seleccione "Preferencias" en el panel de navegacion de la pantalla principal.

## 2. Idioma

La aplicacion se muestra en espanol o ingles. Use el selector desplegable para cambiar entre ambos idiomas. Al seleccionar un idioma, todos los textos y mensajes de la aplicacion se actualizan inmediatamente.

El idioma seleccionado se guarda automaticamente. La proxima vez que inicie la aplicacion, la pantalla de login aparecera en ese idioma.

## 3. Persistencia de usuarios

Seleccione el tipo de almacenamiento para los datos de usuario:

- **Memoria** (predeterminado): los datos se mantienen mientras la aplicacion esta abierta. Al cerrar la aplicacion, los datos se pierden.
- **JSON**: los datos se guardan en el archivo `data/users.json`. Los usuarios persisten entre sesiones de la aplicacion.

El cambio de persistencia se aplica al reiniciar la aplicacion. Al cambiar de JSON a Memoria, el archivo `data/users.json` no se elimina. Si vuelve a JSON, los datos anteriores estaran disponibles.
