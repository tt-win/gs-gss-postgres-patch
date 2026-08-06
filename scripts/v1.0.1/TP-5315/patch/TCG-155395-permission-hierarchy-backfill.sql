-- TP-5315: backfill permissions.parent_id for the permission hierarchy.
-- Must run after TCG-155395-permission-hierarchy-category-permissions.sql
-- (system:view / game:view must already exist). Idempotent — safe to re-run.
SET search_path TO gs_gss, public;

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'system:view')
WHERE code IN ('user:view', 'platform:view', 'currency:view', 'role:view');

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'game:view')
WHERE code IN ('game_list:view');

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'game_list:view')
WHERE code IN ('game_list:edit', 'game_mgmt:edit');

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'platform:view')
WHERE code IN (
    'platform:create', 'platform:edit', 'platform_compliance:edit', 'platform_key_copy:view',
    'platform_key_reset:edit', 'platform_wallet_setting:edit', 'platform_backend_visible:edit',
    'platform_line_enabled:edit', 'platform:delete'
);

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'user:view')
WHERE code IN ('user:create', 'user:edit', 'user_password:edit', 'user:delete');

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'role:view')
WHERE code IN ('role:create', 'role:edit', 'role:delete');

UPDATE permissions SET parent_id = (SELECT id FROM permissions WHERE code = 'currency:view')
WHERE code IN ('currency:create', 'currency:edit', 'currency:delete');
