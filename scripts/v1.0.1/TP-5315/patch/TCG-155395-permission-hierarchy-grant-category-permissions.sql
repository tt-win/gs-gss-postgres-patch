-- TP-5315: grant system:view / game:view to every role that already holds a
-- descendant permission, so RolePermissionPolicy's new ancestor-expansion check
-- doesn't lock existing roles (including Studio Admin) out of managing permissions
-- they already have. Must run after TCG-155395-permission-hierarchy-category-permissions.sql
-- (system:view / game:view must already exist). Idempotent — safe to re-run.
SET search_path TO gs_gss, public;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'system:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN (
    'user:view', 'user:create', 'user:edit', 'user_password:edit', 'user:delete',
    'platform:view', 'platform:create', 'platform:edit', 'platform_compliance:edit',
    'platform_key_copy:view', 'platform_key_reset:edit', 'platform_wallet_setting:edit',
    'platform_backend_visible:edit', 'platform_line_enabled:edit', 'platform:delete',
    'role:view', 'role:create', 'role:edit', 'role:delete',
    'currency:view', 'currency:create', 'currency:edit', 'currency:delete'
)
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'game:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN ('game_list:view', 'game_list:edit', 'game_mgmt:edit')
ON CONFLICT (role_id, permission_id) DO NOTHING;
