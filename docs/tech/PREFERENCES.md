# Preferencias y configuracion

## ILoginPreferences

```pascal
type
  ILoginPreferences = interface
    function LoadLastUsername: string;
    procedure SaveLastUsername(const AUsername: string);
    function LoadLanguage: string;
    procedure SaveLanguage(const ALocale: string);
    function LoadRepositoryType: string;
    procedure SaveRepositoryType(const ARepoType: string);
  end;
```

Implementacion: `TLoginPreferences` (usa `TIniFile`).

## Formato de app.config

```ini
[Login]
LastUsername=admin

[Language]
Default=es

[Repository]
Type=memory    ; memory | file
```

- `[Login] LastUsername` — ultimo usuario que inicio sesion
- `[Language] Default` — idioma al iniciar (`es` | `en`)
- `[Repository] Type` — tipo de repositorio (`memory` | `file`)

## TFramePreferences

Frame embebido en la pestana Preferencias de MainForm.

### Componentes

- `CboLang`: selector de idioma (Espanol/Ingles)
- `CboPersistence`: selector de persistencia (Memoria/JSON)

### Flujo de carga

1. `Configure`: recibe `TLocalizationService` e `ILoginPreferences`
2. Pobla ambos combos con opciones
3. Establece seleccion actual desde `ILoginPreferences.LoadRepositoryType`
4. Establece seleccion de idioma desde `FLocalization.Locale`

### Flujo de guardado

- Al cambiar idioma: `FLocalization.Locale := ...` + `FLoginPreferences.SaveLanguage(...)` + `UpdateTexts` + dispara `OnLanguageChanged`
- Al cambiar persistencia: `FLoginPreferences.SaveRepositoryType(...)`

El cambio de persistencia surte efecto al reiniciar la aplicacion.
