# preferences

## Requirements

### Requirement: Language selection
The system SHALL provide a language selector in the Preferences section.

#### Scenario: Language ComboBox shows available options
- **WHEN** the Preferences section is opened
- **THEN** a ComboBox shows 'Espanol' and 'English' options, preselected with the current language

#### Scenario: Language change updates UI immediately
- **WHEN** user selects a different language in the ComboBox
- **THEN** all visible labels and messages update to the selected language

### Requirement: Language persistence
The system SHALL save the selected language to app.config.

#### Scenario: Selected language is persisted
- **WHEN** user changes the language
- **THEN** the selection is saved to app.config section [Language]

#### Scenario: Language persists across app restarts
- **WHEN** the application is closed and reopened
- **THEN** the login screen appears in the previously selected language
