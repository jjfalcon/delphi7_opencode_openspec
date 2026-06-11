# Autenticacion y sesion

## Componentes

### TBasicPasswordHasher (IPasswordHasher)

Algoritmo de hash basado en **DJB2** (Dan Bernstein):

```
hash = CDJB2HashSeed (5381)
for each char in password:
    hash = ((hash << 5) + hash) + ord(char)
for each char in salt:
    hash = ((hash << 5) + hash) + ord(char)
result = IntToHex(hash, CHashHexLength)  // 8 caracteres hex
```

- `GenerateSalt`: retorna `IntToHex(Random(MaxInt), 8)` (8 caracteres hex aleatorios)
- El salt se almacena junto al usuario (`PasswordSalt`) y se usa al verificar
- Sin DLLs externas ni BCrypt

### TAuthService

- `Login(AUsername, APassword, out AUser): TLoginResult`
- Flujo:
  1. Validar que username y password no esten vacios (`lrUsernameRequired`, `lrPasswordRequired`)
  2. Buscar usuario por username en repositorio (`lrInvalidCredentials` si no existe)
  3. Verificar si cuenta bloqueada (`lrAccountLocked`)
  4. Comparar hash de password ingresado + salt almacenado vs `PasswordHash`
  5.    Si no coincide: incrementar `FailedLoginAttempts`, bloquear si alcanza `CMaxFailedAttempts` (constante 3, definida en `LoginForm.pas`)
  6. Si coincide: resetear `FailedLoginAttempts` a 0, retornar `lrSuccess`

### TSessionService

- `StartSession(AUser)`: establece usuario logueado y timestamp de ultima actividad. Transfiere ownership del `TUser` a `FSessionService`
- `Touch()`: actualiza timestamp (llamado en cada interaccion)
- `IsActive`: verifica que `FLoggedInUser <> nil` y que no haya expirado el timeout
- `EndSession`: limpia usuario y timestamp
- `Destroy`: libera `FLoggedInUser` (elimina leak si se destruye sin `EndSession`)
- Timeout configurable en minutos (se inyecta via constructor)
- Usa `IClock` para ser testeable (evita dependencia directa de `Now`)

### TPermissionService

- `IsAdmin`: sesion activa + usuario con rol `urAdmin`
- `IsLoggedIn`: solo sesion activa

## TLoginResult

| Valor | Significado |
|-------|-------------|
| `lrSuccess` | Login exitoso |
| `lrInvalidCredentials` | Usuario/password incorrectos |
| `lrAccountLocked` | Cuenta bloqueada por 3 intentos fallidos |
| `lrUsernameRequired` | Usuario vacio |
| `lrPasswordRequired` | Password vacio |
