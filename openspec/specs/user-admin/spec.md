# user-admin

## Requirements

### Requirement: Default admin user creation
The system SHALL create a default administrator account on first run if none exists.

#### Scenario: Default admin created on first run
- **WHEN** the application starts and no admin user exists
- **THEN** a default admin user is created with known credentials

#### Scenario: Default admin not duplicated on subsequent runs
- **WHEN** the application starts and an admin user already exists
- **THEN** no additional admin user is created

### Requirement: User management (admin only)
The system SHALL allow admin users to create, view, and manage user accounts.

#### Scenario: Admin can list users
- **WHEN** an admin accesses the user list
- **THEN** all registered users are displayed

#### Scenario: Admin can create a new user
- **WHEN** an admin fills in username, password, and role for a new user
- **THEN** the new user is saved and appears in the user list

#### Scenario: Create user rejects empty username
- **WHEN** an admin tries to create a user with an empty username
- **THEN** the system shows validation error 'admin_username_required'

#### Scenario: Create user rejects empty password
- **WHEN** an admin tries to create a user with an empty password
- **THEN** the system shows validation error 'admin_password_required'

#### Scenario: Create user rejects duplicate username
- **WHEN** an admin tries to create a user with an existing username
- **THEN** the system shows validation error 'admin_username_exists'

#### Scenario: Non-admin cannot access user management
- **WHEN** a regular user attempts to access user management
- **THEN** access is denied
