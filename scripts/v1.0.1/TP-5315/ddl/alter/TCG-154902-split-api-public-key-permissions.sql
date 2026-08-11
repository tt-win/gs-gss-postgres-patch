-- TCG-154902: split API Key vs Public Key permissions (rename platform_key_* → platform_api_key_*; add platform_public_key_reset:edit)
--
-- Post-deploy (with gs-gss-21 same release): flush Redis permission cache so sessions pick up renamed slugs:
--   DEL GS:GSS:USER_PERMISSIONS:*
-- Without flush, cached slugs (platform_key_*) no longer match @PreAuthorize (platform_api_key_*) → 403 until re-login.
SET search_path TO gs_gss, public;

UPDATE permissions
SET code = 'platform_api_key_copy:view',
    name = '平台列表 - API Key 複製',
    description = '複製 API Key',
    updated_time = NOW()
WHERE code = 'platform_key_copy:view';

UPDATE permissions
SET code = 'platform_api_key_reset:edit',
    name = '平台列表 - API Key 重置',
    description = '重置 API Key',
    updated_time = NOW()
WHERE code = 'platform_key_reset:edit';

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time, parent_id)
SELECT
    '平台列表 - Public Key 重置',
    'platform_public_key_reset:edit',
    (SELECT id FROM menus WHERE code = 'platform'),
    'edit',
    3,
    '重置 Public Key（RSA 公鑰）',
    NOW(),
    (SELECT id FROM permissions WHERE code = 'platform:view')
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'platform_public_key_reset:edit');

-- Studio Admin: new slug not in TP-0000 baseline seed.
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions WHERE code = 'platform_public_key_reset:edit'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Preserve prior behavior: roles with platform:edit could reset Public Key before the split.
INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'platform_public_key_reset:edit')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code = 'platform:edit'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Ensure platform:view for holders of the renamed/new key permissions.
INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'platform:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN (
    'platform_api_key_copy:view',
    'platform_api_key_reset:edit',
    'platform_public_key_reset:edit'
)
ON CONFLICT (role_id, permission_id) DO NOTHING;
