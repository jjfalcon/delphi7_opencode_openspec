# User Repository

Requires: user-auth (IUserRepository, TUser)

## Configurable repository backend

The system SHALL support multiple repository backends configurable at startup.

### Scenario: Factory returns Memory repository
- **GIVEN** app.config has `[Repository] Type=memory` (or no setting)
- **WHEN** `TRepositoryFactory.CreateRepository(configPath)` is called
- **THEN** the factory returns a `TInMemoryUserRepository` instance

### Scenario: Factory returns File repository
- **GIVEN** app.config has `[Repository] Type=file`
- **WHEN** `TRepositoryFactory.CreateRepository(configPath)` is called
- **THEN** the factory returns a `TFileUserRepository` instance

## File repository persistence

The system SHALL persist users to a JSON file when using the file repository backend.

### Scenario: Save user writes to file
- **GIVEN** a `TFileUserRepository` instance
- **WHEN** `Save(user)` is called
- **THEN** the JSON file is updated with the new user data

### Scenario: Load users from file on startup
- **GIVEN** a `TFileUserRepository` is created
- **WHEN** the constructor runs
- **THEN** all previously saved users are loaded from the JSON file

### Scenario: FindAll returns all users from file
- **GIVEN** a `TFileUserRepository` instance
- **WHEN** `FindAll` is called
- **THEN** all users from the JSON file are returned

### Scenario: Persistence across instances
- **GIVEN** users saved via a `TFileUserRepository`
- **WHEN** a new `TFileUserRepository` is created pointing to the same config path
- **THEN** the previously saved users are available

## Repository configuration via app.config

The system SHALL read the repository type from app.config section `[Repository]`.

### Scenario: Default repository is memory
- **GIVEN** app.config has no `[Repository]` section
- **WHEN** `TRepositoryFactory.CreateRepository` is called
- **THEN** the factory defaults to `TInMemoryUserRepository`

### Scenario: Repository type is persisted via preferences
- **GIVEN** the Preferences screen
- **WHEN** the user changes the persistence selector
- **THEN** `[Repository] Type` is updated in `app.config`
