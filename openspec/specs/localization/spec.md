# localization

## Requirements

### Requirement: Language file loading
The system SHALL load string resources from INI files organized by language.

#### Scenario: Load strings for Spanish
- **WHEN** the localization service initializes with locale 'es'
- **THEN** it loads all strings from lang/es.ini

#### Scenario: Load strings for English
- **WHEN** the localization service initializes with locale 'en'
- **THEN** it loads all strings from lang/en.ini

#### Scenario: Missing key returns the key itself
- **WHEN** a requested key does not exist in the loaded language file
- **THEN** the service returns the key name as fallback

### Requirement: Default language from config
The system SHALL read the default language from app.config section [Language].

#### Scenario: Read language from config on startup
- **WHEN** the application starts
- **THEN** the localization service reads the Default value from [Language] section

#### Scenario: Fallback to es when no config
- **WHEN** the app.config has no [Language] section
- **THEN** the localization service defaults to 'es'

### Requirement: Language persistence
The system SHALL save the selected language to app.config.

#### Scenario: Save language after selection
- **WHEN** user selects a language in the main form
- **THEN** the selection is saved to app.config [Language] section

### Requirement: Language selector in MainForm
The system SHALL provide a language selector (ComboBox) in the main form.

#### Scenario: ComboBox shows available languages
- **WHEN** the main form opens
- **THEN** a ComboBox shows 'Espanol' and 'English' options, preselected with current language

#### Scenario: Language change updates UI
- **WHEN** user selects a different language in the ComboBox
- **THEN** all visible labels and messages update to the selected language immediately
