# Repositorio de usuarios

## IUserRepository

```pascal
type
  IUserRepository = interface
    ['{11111111-2222-3333-4444-555555555555}']
    function FindById(const AId: string): TUser;
    function FindByUsername(const AUsername: string): TUser;
    function FindAll: TList;
    procedure Add(AUser: TUser);
    procedure Update(AUser: TUser);
    procedure Delete(const AId: string);
  end;
```

- `FindAll` retorna `TList` interno (no copia) por compatibilidad Delphi 7
- `Add` inserta nuevo usuario (toma ownership del objeto; asigna GUID si Id vacio)
- `Update` actualiza campos de usuario existente (caller retiene ownership)
- `Delete` busca por Id y remueve + libera
- `TBaseUserRepository` implementa Template Method con `DoAfterSave`/`DoAfterDelete` virtuales

## TInMemoryUserRepository

Implementacion en memoria usando `TList` interno. Usada por defecto.

## TRepositoryFactory

```pascal
class function TRepositoryFactory.CreateRepository(
  const AConfigPath: string): IUserRepository;
```

Lee `app.config` seccion `[Repository]` usando constantes `CSecRepository` y `CKeyType`:

```ini
[Repository]
Type=memory      ; por defecto
Type=file        ; para persistencia JSON
```

- Si `Type=file`: crea `TFileUserRepository`
- Si `Type=memory` o desconocido: crea `TInMemoryUserRepository`
- La seccion y clave se definen como constantes en `AppCoreRepositoryFactory.pas` y `AppCorePreferences.pas`

## TFileUserRepository

Persistencia JSON a `data/users.json` (relativo al directorio del config).

### Constructor

1. Guarda `FConfigDir := ExtractFilePath(AConfigPath)`
2. `FDataPath := FConfigDir + 'data\' + 'users.json'`
3. Crea directorio `data/` via `ForceDirectories`
4. Llama a `LoadFromFile`

### SaveToFile

Escribe JSON manualmente (sin librerias externas):

```json
{
  "users": [
    {"id":"GUID","username":"alice","passwordHash":"...","passwordSalt":"...","role":"user","isLocked":false,"failedAttempts":0}
  ]
}
```

- `EscapeJSON` escapa `"`, `\`, CR, LF
- GUID generado con `CoCreateGuid` + `GuidToString`, sin llaves `{}`
- Se llama despues de cada `Save` y `Delete`

### LoadFromFile (refactorizada)

Compuesta por 3 metodos extraidos:

1. `ReadEntireFile` — lee todo el archivo como texto plano a string
2. `ExtractUsersArray` — busca `"users": [...]` y retorna el contenido del array
3. `ParseUserBlock` — parsea un bloque `{...}` y retorna `TUser` o `nil` si faltan campos obligatorios

Para cada bloque se extraen campos via `ExtractJSONStr` (soporta valores con/sin comillas). Las llaves `{}` se saltan correctamente incluso si aparecen dentro de valores con comillas.

### Metodos de soporte

- `EscapeJSON` / `UnescapeJSON`: manejo de escape en valores string
- `ExtractJSONStr(const ALine, AKey): string`: extrae valor de un campo JSON clave:valor
- `NewGuidString`: genera GUID unico para `Id`

### NewGuidString

```pascal
function NewGuidString: string;
var
  LGuid: TGuid;
begin
  if CoCreateGuid(LGuid) = S_OK then
    Result := GuidToString(LGuid);
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;
```

Requiere `CoInitializeEx` previo (llamado en `WindowsApp.dpr`).

### Observaciones

- JSON plano manual: no hay parser completo. Solo para estructura conocida.
- No soporta valores anidados ni arrays dentro de objetos.
- Tampoco usa `TJSONObject` o similares (no disponibles en Delphi 7 sin librerias externas).
