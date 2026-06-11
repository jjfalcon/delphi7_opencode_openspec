## 1. Test Setup

- [x] 1.1 Write tests for `EditUser` (success, validation errors, permission denied)
- [x] 1.2 Write tests for `DeleteUser` (success, permission denied)

## 2. Core Implementation

- [x] 2.1 Implement `EditUser(AUserId, AUsername, APassword, ARole, out AError): Boolean` with validation and password change logic
- [x] 2.2 Implement `DeleteUser(AUserId, out AError): Boolean` with permission check
- [x] 2.3 Compile and verify all tests pass (new + existing)

## 3. VCL UI

- [x] 3.1 Add `BtnEditUser` and `BtnDeleteUser` to `UserAdminFrame` + `.dfm`
- [x] 3.2 Wire `BtnEditUserClick`: populate create fields from selected user, call `EditUser` on save
- [x] 3.3 Wire `BtnDeleteUserClick`: show confirmation dialog, call `DeleteUser` on confirm
- [x] 3.4 Add `LstUsers` click handler to enable/disable edit/delete buttons based on selection

## 4. Localization

- [x] 4.1 Add edit/delete keys to `lang/es.ini`
- [x] 4.2 Add edit/delete keys to `lang/en.ini`

## 5. Documentation

- [x] 5.1 Update `docs/user_manual/USERS.md` with edit/delete instructions
