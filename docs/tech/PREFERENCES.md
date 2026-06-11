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

Implementacion: `TLoginPreferences` (usa `TIniFile` con `try-finally Free` en todos los metodos).

Las claves de seccion y campo se definen como constantes con nombre:
- `CSecLogin`, `CKeyLastUsername`
- `CSecLanguage`, `CKeyDefault`
- `CSecRepository`, `CKeyType`

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
2. Limpia ambos combos (`Items.Clear`) para evitar duplicados si `Configure` se llama mas de una vez
3. Pobla ambos combos con opciones desde arreglos constantes (`LANG_DISPLAY`, `LANG_LOCALES`, `REPO_DISPLAY`, `REPO_VALUES`)
4. Establece seleccion actual desde `ILoginPreferences.LoadRepositoryType`
5. Establece seleccion de idioma desde `FLocalization.Locale`

### Flujo de guardado

- Al cambiar idioma: `FLocalization.Locale := ...` + `FLoginPreferences.SaveLanguage(...)` + `UpdateTexts` + dispara `OnLanguageChanged`
- Al cambiar persistencia: `FLoginPreferences.SaveRepositoryType(...)`

El cambio de persistencia surte efecto al reiniciar la aplicacion.
