-- TP-5315: grant each menu-level view (user:view, platform:view, role:view,
-- currency:view, game_list:view) to every role that already holds a descendant
-- action permission but not the menu view itself, so RolePermissionPolicy's new
-- ancestor-expansion check doesn't lock existing roles out of permissions they
-- already have. This is the menu-level counterpart of
-- TCG-155395-permission-hierarchy-grant-category-permissions.sql (which only
-- backfills the category level); together they satisfy the "既有角色遷移"
-- requirement of auto-completing the full ancestor chain (menu view + category
-- view). Order relative to that script does not matter — both trigger on the
-- original action codes. Idempotent — safe to re-run.
SET search_path TO gs_gss, public;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'user:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN ('user:create', 'user:edit', 'user_password:edit', 'user:delete')
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'platform:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN (
    'platform:create', 'platform:edit', 'platform_compliance:edit', 'platform_key_copy:view',
    'platform_key_reset:edit', 'platform_wallet_setting:edit', 'platform_backend_visible:edit',
    'platform_line_enabled:edit', 'platform:delete'
)
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'role:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN ('role:create', 'role:edit', 'role:delete')
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'currency:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN ('currency:create', 'currency:edit', 'currency:delete')
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT DISTINCT rp.role_id, (SELECT id FROM permissions WHERE code = 'game_list:view')
FROM role_permissions rp
JOIN permissions p ON p.id = rp.permission_id
WHERE p.code IN ('game_list:edit', 'game_mgmt:edit')
ON CONFLICT (role_id, permission_id) DO NOTHING;
