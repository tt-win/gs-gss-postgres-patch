-- Source: gs-gss-21/src/main/resources/db/dev-seed/V3__gss_dev_seed.sql
SET search_path TO gs_gss, public;

INSERT INTO roles (id, name, description, role_type, protected, active, owner_user_id, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'Studio Admin', 'GSS 全權限（Studio）', 'studio', true, true, NULL, NOW()),
    (2, 'Master Agent Default', '總代理預設：平台／使用者／角色／遊戲列表', 'master_agent', true, true, NULL, NOW()),
    (3, 'Sub Account Default', '子帳號預設：使用者檢視＋修改密碼', 'sub_account', true, true, NULL, NOW())
ON CONFLICT (id) DO UPDATE SET
    name        = EXCLUDED.name,
    description = EXCLUDED.description,
    role_type   = EXCLUDED.role_type,
    protected   = EXCLUDED.protected,
    active      = EXCLUDED.active;

-- Rebuild default role permission sets (ids 1–3)
DELETE FROM role_permissions WHERE role_id IN (1, 2, 3);

INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions
WHERE code IN (
    'platform:view', 'platform:create', 'platform:edit',
    'currency_options:view',
    'platform_key_copy:view', 'platform_key_reset:edit',
    'platform_wallet_setting:edit', 'platform_wallet_test:edit',
    'role:view', 'role:create', 'role:edit', 'role:delete',
    'user:view', 'user:create', 'user:edit', 'user:delete', 'user_password:edit',
    'game_setting:view', 'game_setting:edit'
)
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, id FROM permissions
WHERE code IN ('user:view', 'user_password:edit')
ON CONFLICT (role_id, permission_id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('roles', 'id'), (SELECT COALESCE(MAX(id), 1) FROM roles));
