# Repositorio de usuarios

## IUserRepository

```pascal
type
  IUserRepository = interface
    ['{11111111-2222-3333-4444-555555555555}']
    function FindById(const AId: string): TUser;
    function FindByUsername(const AUsername: string): TUser;
    function FindAll: TList;
    procedure Save(AUser: TUser);
    procedure Delete(const AId: string);
  end;
```

- `FindAll` retorna `TList` interno (no copia) por compatibilidad Delphi 7
- `Save` inserta si es nuevo (Id vacio) o actualiza si ya existe
- `Delete` busca por Id y remueve + libera

## TInMemoryUserRepository

Implementacion en memoria usando `TList` interno. Usada por defecto.

## TRepositoryFactory

```pascal
class function TRepositoryFactory.CreateRepository(
  const AConfigPath: string): IUserRepository;
```

Lee `app.config` seccion `[Repository]`:

```ini
[Repository]
Type=memory      ; por defecto
Type=file        ; para persistencia JSON
```

- Si `Type=file`: crea `TFileUserRepository`
- Si `Type=memory` o desconocido: crea `TInMemoryUserRepository`

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

### LoadFromFile

1. Lee todo el archivo como texto plano
2. Busca `"users": [...]`
3. Para cada bloque `{...}`, extrae campos via `ExtractJSONStr`
4. `ExtractJSONStr` soporta valores con comillas (string) y sin comillas (boolean, integer)
5. Las llaves `{}` se saltan correctamente incluso si aparecen dentro de valores con comillas

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
