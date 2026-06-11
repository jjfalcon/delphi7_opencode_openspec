## Why

User administration currently supports creating users but not editing or deleting them. Admins cannot update a user's role, reset a password, or remove accounts, limiting basic account lifecycle management.

## What Changes

- **Edit user**: admin can modify username, password, and role of an existing user
- **Delete user**: admin can remove a user account from the system
- **Update spec**: add edit/delete scenarios to `user-admin`
- **Update UI**: UserAdminFrame gets edit/delete controls
- No breaking changes to existing APIs — `IUserRepository.Add`/`Update`/`Delete` already support the required operations

## Capabilities

### New Capabilities
*(none — extends existing capability)*

### Modified Capabilities
- `user-admin`: add requirements for editing and deleting users (password reset, role change, account removal)

## Impact

- `AppCoreUserManagement.pas` — add `EditUser` and `DeleteUser` methods
- `UserAdminFrame.pas` — add UI controls: edit button, delete button, in-place editing or dialog
- `tests/App.Core.Tests/AppCoreUserManagementTests.pas` — add test scenarios for edit and delete
- `docs/user_manual/USERS.md` — update with edit/delete instructions
- `lang/es.ini`, `lang/en.ini` — add new localization keys for edit/delete UI
