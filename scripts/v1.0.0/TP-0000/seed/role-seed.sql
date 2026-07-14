-- Source: gs-gss-21/docs/GSS_REQUIRED_PERMISSIONS.md
-- Default grants: §一總表「總代理／子帳號」操作欄 + §五查核（mask 為可授上界，預設角色仍手選子集）
SET search_path TO gs_gss, public;

INSERT INTO roles (id, name, description, role_type, protected, active, owner_user_id, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'Studio Admin', 'GSS 全權限（Studio）', 'studio', true, true, NULL, NOW()),
    (2, 'Master Agent Default', '總代理預設：平台／使用者／角色／遊戲列表', 'master_agent', true, true, NULL, NOW()),
    (3, 'Sub Account Default', '子帳號預設：使用者檢視（唯讀列表）', 'sub_account', true, true, NULL, NOW())
ON CONFLICT (id) DO UPDATE SET
    name        = EXCLUDED.name,
    description = EXCLUDED.description,
    role_type   = EXCLUDED.role_type,
    protected   = EXCLUDED.protected,
    active      = EXCLUDED.active;

-- Rebuild default role permission sets (ids 1–3)
DELETE FROM role_permissions WHERE role_id IN (1, 2, 3);

-- Role 1: Studio Admin — 全部 Phase 1 permissions（28 slugs）
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Role 2: Master Agent Default — §7 總代理欄非「—」+ §8 總代理✓ + §3 game_setting（不含 game_listing:edit）
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions
WHERE code IN (
    -- §7 平台管理
    'platform:view',
    'platform:create',
    'currency_options:view',
    'platform:edit',
    'platform_key_copy:view',
    'platform_key_reset:edit',
    'platform_wallet_setting:edit',
    'platform_wallet_test:edit',
    -- §8 使用者管理（列表列操作：總代理✓）
    'user:view',
    'user:create',
    'user:edit',
    'user_password:edit',
    'user:delete',
    -- §8 角色管理（角色列表列操作：總代理✓）
    'role:view',
    'role:create',
    'role:edit',
    'role:delete',
    -- §3 遊戲列表（mask=7；不含 game_listing:edit mask=1）
    'game_setting:view',
    'game_setting:edit'
);

-- Role 3: Sub Account Default — §五查核「子帳號預設僅 user:view」
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, id FROM permissions
WHERE code IN ('user:view');

SELECT setval(pg_get_serial_sequence('roles', 'id'), (SELECT COALESCE(MAX(id), 1) FROM roles));
