# user-auth

## Requirements

### Requirement: User login
The system SHALL authenticate users with username and password. All user-facing messages SHALL be translatable via TLocalizationService.

#### Scenario: Successful login with valid credentials
- **WHEN** user enters correct username and password
- **THEN** the system creates a session and grants access

#### Scenario: Login fails with invalid password
- **WHEN** user enters correct username but wrong password
- **THEN** the system rejects login and shows translated error key 'login_invalid_credentials'

#### Scenario: Login fails with non-existent user
- **WHEN** user enters a username that does not exist
- **THEN** the system rejects login and shows translated error key 'login_invalid_credentials'

#### Scenario: Empty username is rejected
- **WHEN** user submits login with empty username
- **THEN** the system shows translated validation error key 'login_username_required'

#### Scenario: Empty password is rejected
- **WHEN** user submits login with empty password
- **THEN** the system shows translated validation error key 'login_password_required'

### Requirement: Account lockout after failed attempts
The system SHALL lock a user account after 3 consecutive failed login attempts.

#### Scenario: Account is locked after 3 failed attempts
- **WHEN** user fails to login 3 times consecutively
- **THEN** the account is locked and shows translated error key 'login_account_locked'

#### Scenario: Successful login resets failed attempt counter
- **WHEN** user logs in successfully after previous failures
- **THEN** the failed attempt counter is reset to zero

### Requirement: Session with inactivity timeout
The system SHALL maintain an active session and expire it after 5 minutes of inactivity.

#### Scenario: Active session is valid
- **WHEN** user has logged in and is within the inactivity period
- **THEN** the session is reported as active

#### Scenario: Session expires after inactivity
- **WHEN** user has been inactive for more than 5 minutes
- **THEN** the session is expired and user is logged out

### Requirement: User roles
The system SHALL support administrator and regular user roles.

#### Scenario: Admin user has admin role
- **WHEN** an admin user logs in
- **THEN** the session reflects "admin" role

#### Scenario: Regular user has user role
- **WHEN** a regular user logs in
- **THEN** the session reflects "user" role

### Requirement: Remember last username
The system SHALL remember the last username used for login.

#### Scenario: Last username is saved after login
- **WHEN** user logs in successfully
- **THEN** the system saves the username for pre-fill on next launch

#### Scenario: Last username is pre-filled on login form
- **WHEN** the login form opens and a previous username was saved
- **THEN** the username field is pre-filled with that value
