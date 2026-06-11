## ADDED Requirements

### Requirement: Configurable repository backend
The system SHALL support multiple repository backends configurable at startup.

#### Scenario: Factory returns Memory repository
- **WHEN** the application starts with repository type 'memory'
- **THEN** the factory returns a TInMemoryUserRepository instance

#### Scenario: Factory returns File repository
- **WHEN** the application starts with repository type 'file'
- **THEN** the factory returns a TFileUserRepository instance

### Requirement: File repository persistence
The system SHALL persist users to a JSON file when using the file repository backend.

#### Scenario: Save user writes to file
- **WHEN** a user is saved via TFileUserRepository
- **THEN** the JSON file is updated with the new user data

#### Scenario: Load users from file on startup
- **WHEN** the application starts with 'file' repository type
- **THEN** all previously saved users are loaded from the JSON file

#### Scenario: FindAll returns all users from file
- **WHEN** FindAll is called on TFileUserRepository
- **THEN** all users from the JSON file are returned

### Requirement: Repository configuration via app.config
The system SHALL read the repository type from app.config section [Repository].

#### Scenario: Default repository is memory
- **WHEN** no repository type is configured in app.config
- **THEN** the factory defaults to TInMemoryUserRepository

#### Scenario: Repository type is read from config
- **WHEN** app.config has [Repository] Type=file
- **THEN** the factory returns TFileUserRepository
