## Why

The application currently has no user management interface. Admin users cannot create new accounts or view existing users. This limits the app to only the default admin account.

## What Changes

- New user management form accessible only to admin users
- User list showing all registered accounts
- Ability to create new users with username, password, and role selection
- Button in MainForm for admin users to open management
- Permission check preventing non-admin access

## Capabilities

### New Capabilities

- `user-admin`: Admin-only user management with user listing and account creation

### Modified Capabilities

(No existing capability requirements change - user-admin is already spec'd)

## Impact

- New VCL form: `AppWinAdminForm.pas` + `.dfm` (user management dialog)
- Modified: `MainForm.pas` + `.dfm` (add admin button, visible only for admin role)
- Core: `AppCoreUserRepository.pas` already has `FindAll` - no new core service needed
- Tests: new test scenarios for admin-only access, user creation via repo
