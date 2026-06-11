# users

## Requirements

### Requirement: User list
The system SHALL display all registered users for admin users.

#### Scenario: Admin can view all users
- **WHEN** an admin accesses the Users section
- **THEN** all registered users are listed with username and role

#### Scenario: Regular user cannot access user list
- **WHEN** a regular user attempts to access the Users section
- **THEN** the option is not visible in navigation

### Requirement: Create user
The system SHALL allow admin users to create new user accounts.

#### Scenario: Create user with valid data
- **WHEN** an admin enters a username, password, and role
- **THEN** the new user is created and appears in the user list

#### Scenario: Create user rejects empty username
- **WHEN** an admin tries to create a user with an empty username
- **THEN** the system shows validation error 'admin_username_required'

#### Scenario: Create user rejects empty password
- **WHEN** an admin tries to create a user with an empty password
- **THEN** the system shows validation error 'admin_password_required'

#### Scenario: Create user rejects duplicate username
- **WHEN** an admin tries to create a user with an existing username
- **THEN** the system shows validation error 'admin_username_exists'
