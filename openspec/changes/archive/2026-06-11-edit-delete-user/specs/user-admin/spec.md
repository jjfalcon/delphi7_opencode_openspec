## ADDED Requirements

### Requirement: Admin can edit a user
The system SHALL allow admin users to modify an existing user's username, password, and role.

#### Scenario: Admin edits username
- **WHEN** an admin selects an existing user and changes the username to a non-empty, non-duplicate value
- **THEN** the user's username is updated in the repository

#### Scenario: Admin edits role
- **WHEN** an admin changes a user's role from User to Admin (or vice versa)
- **THEN** the user's role is updated in the repository

#### Scenario: Admin changes password
- **WHEN** an admin enters a new non-empty password for a user
- **THEN** the user's password hash is recalculated and stored

#### Scenario: Admin edits username without changing password
- **WHEN** an admin changes the username but leaves the password field empty
- **THEN** the existing password hash is preserved

#### Scenario: Edit user rejects empty username
- **WHEN** an admin tries to save a user with an empty username
- **THEN** the system shows validation error 'admin_username_required'

#### Scenario: Edit user rejects duplicate username
- **WHEN** an admin tries to change a user's username to one that already exists
- **THEN** the system shows validation error 'admin_username_exists'

#### Scenario: Non-admin cannot edit users
- **WHEN** a regular user attempts to edit a user
- **THEN** the operation is denied

### Requirement: Admin can delete a user
The system SHALL allow admin users to delete user accounts.

#### Scenario: Admin deletes a user
- **WHEN** an admin selects a user and confirms deletion
- **THEN** the user is removed from the repository

#### Scenario: Admin cancels deletion
- **WHEN** an admin selects a user but cancels the confirmation dialog
- **THEN** the user is not removed from the repository

#### Scenario: Non-admin cannot delete users
- **WHEN** a regular user attempts to delete a user
- **THEN** the operation is denied
