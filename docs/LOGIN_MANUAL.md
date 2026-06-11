# Manual de Usuario - Inicio de Sesion

## 1. Introduccion

SDD OpenSpec App es una aplicacion de escritorio para Windows. No requiere instalacion: solo ejecute el archivo `WindowsApp.exe`.

## 2. Inicio de Sesion

Al abrir la aplicacion aparece la pantalla de inicio de sesion con los siguientes campos:

- **Usuario:** ingrese su nombre de usuario
- **Contrasena:** ingrese su contrasena (se oculta mientras escribe)

Botones:

- **Ingresar:** inicia sesion con los datos ingresados
- **Cancelar:** cierra la aplicacion

### 2.1. Inicio de sesion exitoso

Si los datos son correctos, ingresara a la pantalla principal donde se muestra un mensaje de bienvenida con su nombre de usuario y su rol (Administrador o Usuario).

### 2.2. Cierre de sesion

En la pantalla principal, haga clic en "Cerrar sesion" para volver a la pantalla de inicio de sesion.

## 3. Idioma

La aplicacion se muestra en espanol o ingles. El idioma se selecciona desde la pantalla principal mediante el selector desplegable. Al cambiar el idioma, todos los textos y mensajes se actualizan inmediatamente.

El idioma seleccionado se guarda automaticamente. La proxima vez que inicie la aplicacion, la pantalla de login aparecera en ese idioma.

## 4. Mensajes de Error

| Mensaje | Significado | Que hacer |
|---------|-------------|-----------|
| "Usuario o contrasena incorrectos" | El usuario o la contrasena no coinciden | Verifique sus datos e intente nuevamente |
| "Cuenta bloqueada. Contacte al administrador." | La cuenta se bloqueo por 3 intentos fallidos | Contacte al administrador del sistema |
| "El usuario es obligatorio" | No ingreso un nombre de usuario | Escriba su usuario en el campo correspondiente |
| "La contrasena es obligatoria" | No ingreso una contrasena | Escriba su contrasena en el campo correspondiente |

## 5. Cuenta Bloqueada

Por seguridad, la cuenta se bloquea automaticamente despues de 3 intentos fallidos consecutivos de inicio de sesion. Si su cuenta queda bloqueada, solo un administrador puede desbloquearla.

Para evitar el bloqueo:

- Verifique que la tecla Bloq Mayus no este activada
- Confirme que esta usando el nombre de usuario correcto
- Si olvido su contrasena, contacte al administrador

## 6. Credenciales por Defecto

La primera vez que se ejecuta la aplicacion, existe una cuenta de administrador predefinida:

- **Usuario:** admin
- **Contrasena:** admin

Se recomienda cambiar la contrasena por defecto en un entorno de produccion.
