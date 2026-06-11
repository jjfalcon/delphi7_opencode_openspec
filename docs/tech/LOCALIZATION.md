# Localizacion (i18n)

## TLocalizationService

Servicio de internacionalizacion basado en archivos INI.

```pascal
constructor Create(const ALangDir, ALocale: string);
function GetString(const AKey: string): string;
property Locale: string read FLocale write FLocale;
```

### Funcionamiento

1. `GetString(AKey)` lee `[Strings]` seccion del archivo `<ALangDir>\<ALocale>.ini`
2. Si la clave no existe, retorna el nombre de la clave como fallback
3. `Locale := 'en'` cambia el idioma; las proximas llamadas a `GetString` usaran el nuevo archivo

### Formato de archivo

```ini
[Strings]
login_title=Inicio de Sesion
login_username=Usuario:
...
```

### Archivos

- `lang/es.ini` — Espanol
- `lang/en.ini` — Ingles

Ambos archivos deben tener las mismas claves bajo `[Strings]`.

### Uso en UI

Cada frame/ventana llama a `FLocalization.GetString('clave')` al configurarse y al cambiar de idioma via `UpdateTexts`.

### Convencion de claves

- `login_*` — Pantalla de login
- `main_*` — Pantalla principal (bienvenida, navegacion, preferencias)
- `nav_*` — Items de navegacion
- `admin_*` — Administracion de usuarios
