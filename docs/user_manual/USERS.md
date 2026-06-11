# Manual de Usuario - Administracion de Usuarios

## 1. Acceso

La opcion "Usuarios" en el panel de navegacion solo es visible para usuarios con rol de Administrador. Si no ve esta opcion, no tiene permisos para administrar cuentas.

## 2. Lista de Usuarios

Al seleccionar "Usuarios" se muestra una lista con todas las cuentas registradas, indicando el nombre de usuario y su rol (Admin o User).

## 3. Crear Usuario

Para crear un nuevo usuario:

1. Complete el campo **Usuario** con el nombre de la nueva cuenta
2. Complete el campo **Contrasena** con la contrasena deseada
3. Seleccione el **Rol** (Usuario o Administrador)
4. Haga clic en **Crear**

Si los datos son correctos, el nuevo usuario aparecera en la lista y podra iniciar sesion inmediatamente.

### 3.1. Errores al crear usuario

| Mensaje | Significado |
|---------|-------------|
| "El usuario es obligatorio" | Debe escribir un nombre de usuario |
| "La contrasena es obligatoria" | Debe escribir una contrasena |
| "El usuario ya existe" | Ya hay una cuenta con ese nombre |

## 4. Editar Usuario

Para editar un usuario existente:

1. Seleccione un usuario de la lista
2. Modifique los campos **Usuario**, **Contrasena** y **Rol** segun sea necesario
3. Haga clic en **Editar**

Para conservar la contrasena actual, deje el campo **Contrasena** vacio.

### 4.1. Errores al editar usuario

| Mensaje | Significado |
|---------|-------------|
| "El usuario es obligatorio" | Debe escribir un nombre de usuario |
| "El usuario ya existe" | Ya hay otra cuenta con ese nombre |
| "Permiso denegado" | No tiene permisos para editar usuarios |

## 5. Eliminar Usuario

Para eliminar un usuario:

1. Seleccione un usuario de la lista
2. Haga clic en **Eliminar**
3. Confirme la eliminacion en el dialogo de confirmacion

La operacion no se puede deshacer.

### 5.1. Errores al eliminar usuario

| Mensaje | Significado |
|---------|-------------|
| "Permiso denegado" | No tiene permisos para eliminar usuarios |
| "Usuario no encontrado" | El usuario fue eliminado por otro administrador |
