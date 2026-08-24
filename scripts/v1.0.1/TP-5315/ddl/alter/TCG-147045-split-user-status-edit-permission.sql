-- TCG-147045: split user status toggle (PUT /users/{id}/status) out of user:edit
-- into its own permission user_status:edit, so status enable/disable can be
-- granted independently of general user editing.
--
-- Post-deploy (with gs-gss-21 same release): flush Redis permission cache so sessions pick up the new slug:
--   DEL GS:GSS:USER_PERMISSIONS:*
-- Without flush, existing sessions won't see user_status:edit until re-login.
SET search_path TO gs_gss, public;

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time, parent_id)
SELECT
    '使用者管理 - 啟用／停用',
    'user_status:edit',
    (SELECT id FROM menus WHERE code = 'user'),
    'edit',
    3,
    '啟用／停用使用者帳號（自 user:edit 拆分）',
    NOW(),
    (SELECT id FROM permissions WHERE code = 'user:view')
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'user_status:edit');

-- Studio Admin: new slug not in TP-0000 baseline seed.
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions WHERE code = 'user_status:edit'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Preserve prior behavior: roles with user:edit could toggle status before the split.
INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'user_status:edit')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code = 'user:edit'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Ensure user:view for holders of the new status-edit permission.
INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'user:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code = 'user_status:edit'
ON CONFLICT (role_id, permission_id) DO NOTHING;
