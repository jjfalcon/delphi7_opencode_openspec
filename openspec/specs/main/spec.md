# main

## Requirements

### Requirement: Navigation panel
The system SHALL display a navigation panel on the left side of the main screen.

#### Scenario: Navigation shows available sections
- **WHEN** the main screen opens
- **THEN** the navigation panel shows 'Inicio', 'Usuarios', and 'Preferencias' options

#### Scenario: Navigation hides admin-only sections for regular users
- **WHEN** a regular user opens the main screen
- **THEN** the 'Usuarios' option is not shown in the navigation panel

### Requirement: Welcome view
The system SHALL show a welcome view in the center panel by default.

#### Scenario: Welcome shows user info after login
- **WHEN** user logs in successfully and reaches the main screen
- **THEN** the center panel shows a welcome message with the username and role

#### Scenario: Selecting a nav option changes center content
- **WHEN** user clicks a navigation option
- **THEN** the center panel displays the corresponding section content

### Requirement: Logout
The system SHALL provide a logout button on the main screen.

#### Scenario: Logout returns to login screen
- **WHEN** user clicks 'Cerrar sesion'
- **THEN** the session ends and the login screen is shown
