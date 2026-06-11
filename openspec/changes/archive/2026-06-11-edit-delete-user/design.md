## Context

User administration (`UserAdminFrame` + `TUserManagementService`) currently supports only user creation. The underlying `IUserRepository` already provides `Update` and `Delete` methods, and `TUserManagementService` already checks `FPermission.IsAdmin`. The missing pieces are the business logic in the service and the UI controls in the frame.

## Goals / Non-Goals

**Goals:**
- Admin can edit an existing user (username, password, role)
- Admin can delete an existing user (remove from repo)
- Proper validation for edit (empty fields, duplicate username)
- Confirmation before delete
- Full test coverage for new methods
- Localized UI strings for edit/delete

**Non-Goals:**
- Bulk operations
- Audit log of changes
- Password confirmation prompt (not needed for admin)

## Decisions

| Decision | Rationale |
|----------|-----------|
| **Edit selected user from list** instead of separate dialog | Reuses existing create fields (EdtNewUsername, EdtNewPassword, CboNewRole) by populating them from the selected user; avoids adding a new form |
| **BtnEditUser and BtnDeleteUser added next to user list** | Standard pattern: select from list, then act. Keeps layout consistent |
| **`EditUser` takes `AUserId` + fields** instead of `TUser` | Clear ownership: the service finds the user, modifies, and calls `Update`. Caller retains ownership of any passed `TUser` |
| **Password change optional** — if new password is empty, keep existing hash | Allows editing username/role without re-entering password |
| **Delete confirmation via `MessageDlg`** (VCL) instead of custom dialog | Simple, fast to implement, consistent with Delphi patterns. A thin UI concern, acceptable in VCL layer |
| **`EditUser` reuses `admin_username_exists` error key** | Existing localization key already describes the condition |

## Risks / Trade-offs

- [Risk] User selects different user after populating fields → [Mitigation] Clear fields when selection changes, or use the selected user at edit time (current design uses the selection at edit time)
- [Risk] Admin deletes own account → [Mitigation] Prevent deleting the currently logged-in user (requires session info). Out of scope for now — documented as non-goal.
