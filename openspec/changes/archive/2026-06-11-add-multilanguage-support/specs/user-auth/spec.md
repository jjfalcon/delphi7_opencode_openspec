## MODIFIED Requirements

### Requirement: User login
The system SHALL authenticate users with username and password. All user-facing messages SHALL be translatable via TLocalizationService.

#### Scenario: Successful login with valid credentials
- **WHEN** user enters correct username and password
- **THEN** the system creates a session and grants access

#### Scenario: Login fails with invalid password
- **WHEN** user enters correct username but wrong password
- **THEN** the system rejects login and shows translated error message key 'login_invalid_credentials'

#### Scenario: Login fails with non-existent user
- **WHEN** user enters a username that does not exist
- **THEN** the system rejects login and shows translated error message key 'login_invalid_credentials'

#### Scenario: Empty username is rejected
- **WHEN** user submits login with empty username
- **THEN** the system shows translated validation error key 'login_username_required'

#### Scenario: Empty password is rejected
- **WHEN** user submits login with empty password
- **THEN** the system shows translated validation error key 'login_password_required'

### Requirement: Account lockout after failed attempts

#### Scenario: Account is locked after 3 failed attempts
- **WHEN** user fails to login 3 times consecutively
- **THEN** the account is locked and shows translated error key 'login_account_locked'

