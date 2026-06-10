# Reglas del proyecto

## Stack
- Delphi 7, VCL Windows, test runner propio (sin paquetes externos)
- `src/App.Core` → reglas de negocio, interfaces, servicios
- `src/App.Win` → capa VCL fina, sin reglas de negocio
- `tests/App.Core.Tests` → pruebas de consola del núcleo
- `docs/` → specs funcionales (`*_SPEC.md`), técnicas (`*_TECH.md`), manuales (`*_MANUAL.md`)
- OpenSpec para spec-driven development (SDD)

## TDD obligatorio
1. Escribir la prueba primero en `tests/App.Core.Tests`
2. Ejecutar y verla fallar (rojo)
3. Implementar lo mínimo en `src/App.Core` para que pase (verde)
4. Refactorizar sin cambiar comportamiento
5. Solo entonces conectar desde `src/App.Win`

## Qué probar
- Validaciones de entrada, casos de error, cambios de estado
- Búsquedas y filtros, reglas de permiso, persistencia con repositorios fake

## Qué NO va en la UI
- La ventana llama a servicios del núcleo, no contiene lógica de negocio
- No generar eventos VCL con reglas de validación o negocio

## Convenciones de código Delphi 7
- Unit names: `AppCore<NombredelClase>.pas` (Core), `AppWin<NombredelForm>.pas` (VCL)
- Clases con prefijo `T`, interfaces con prefijo `I`
- Indentación: 2 espacios, begin/end alineados
- Nombres de métodos en PascalCase
- Atributos privados con prefijo `F`
- Properties públicas con mismo nombre que campo privado sin prefijo
- Archivos .dfm en texto (no binario) — guardar con "View as Text"
- Sin paquetes externos ni frameworks: solo VCL estándar de Delphi 7
- Sin clases genéricas ni características post-Delphi 7
- Gestión manual de memoria: TObject.Create / Free / try-finally

## OpenSpec
- Cada feature nueva empieza con `/opsx:propose "nombre-del-cambio"`
- Seguir los artefactos: proposal → specs → design → tasks
- Al terminar: `/opsx:archive`
- Specs viven en `docs/` con sufijo `_SPEC.md`
