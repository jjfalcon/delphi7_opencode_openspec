## 1. Core - Servicio de Localizacion

- [x] 1.1 Crear TLocalizationService en AppCoreLocalization.pas (carga INI por locale, metodo GetString)
- [x] 1.2 Escribir tests: carga de idioma, clave faltante, default locale

## 2. Archivos de Idioma

- [x] 2.1 Crear lang/es.ini con todos los textos actuales de LoginForm y MainForm
- [x] 2.2 Crear lang/en.ini con traduccion al ingles

## 3. Modificar LoginForm

- [x] 3.1 Agregar TLocalizationService como dependencia inyectada
- [x] 3.2 Reemplazar strings literales por llamadas a GetString

## 4. Modificar MainForm

- [x] 4.1 Agregar TLocalizationService como dependencia inyectada
- [x] 4.2 Reemplazar strings literales por llamadas a GetString
- [x] 4.3 Agregar ComboBox de selector de idioma
- [x] 4.4 Conectar cambio de idioma con actualizacion de labels en MainForm

## 5. Configuracion

- [x] 5.1 Agregar seccion [Language] con Default=es en app.config
- [x] 5.2 Persistir idioma seleccionado al cambiar

## 6. Integracion

- [x] 6.1 Inicializar TLocalizationService en WindowsApp.dpr
- [x] 6.2 Inyectar servicio en LoginForm y MainForm
- [x] 6.3 Agregar unidades al DPR de tests y app Windows

## 7. Verificacion

- [x] 7.1 Compilar tests y verificar que pasan
- [x] 7.2 Compilar WindowsApp
- [x] 7.3 Ejecutar y probar cambio de idioma en tiempo real
