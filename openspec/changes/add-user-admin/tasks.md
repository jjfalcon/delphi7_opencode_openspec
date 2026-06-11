## 1. Core - Servicios

- [ ] 1.1 Crear TUserManagementService en AppCoreUserManagement.pas (CreateUser, GetUsers, CanManage)
- [ ] 1.2 Escribir tests: crear usuario v&aacute;lido, username vac&iacute;o, password vac&iacute;a, duplicado, permiso admin

## 2. Frames (VCL)

- [ ] 2.1 Crear AppWinPreferencesFrame.pas + .dfm (ComboBox idioma, actualiza labels v&iacute;a evento)
- [ ] 2.2 Crear AppWinUserAdminFrame.pas + .dfm (lista usuarios, campos crear + bot&oacute;n)

## 3. Redise&ntilde;o MainForm

- [ ] 3.1 Agregar TListBox navegaci&oacute;n izquierda (Inicio, Usuarios, Preferencias)
- [ ] 3.2 Agregar TPanel central para contenido din&aacute;mico
- [ ] 3.3 Conectar navegaci&oacute;n: mostrar/ocultar frames, welcome por defecto
- [ ] 3.4 Ocultar item "Usuarios" si no es admin
- [ ] 3.5 Quitar ComboBox idioma standalone (ahora en frame)

## 4. Integraci&oacute;n

- [ ] 4.1 Agregar unidades a WindowsApp.dpr
- [ ] 4.2 Agregar unidades a tests DPR
- [ ] 4.3 Conectar servicios en WindowsApp.dpr

## 5. Verificaci&oacute;n

- [ ] 5.1 Compilar y ejecutar tests
- [ ] 5.2 Compilar WindowsApp
- [ ] 5.3 Probar: login admin, ver nav completa, crear usuario, cambiar idioma
