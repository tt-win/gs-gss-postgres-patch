-- Source: TP-5315 / TCG-147021~056 Phase 1 permissions
-- Permissions: docs/GSS_REQUIRED_PERMISSIONS.md §一（Phase 1 子集，28 slugs）
SET search_path TO gs_gss, public;

-- TP-0000 baseline owns the full permissions catalog; wipe and reset id sequence
TRUNCATE permissions RESTART IDENTITY;

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
VALUES
    -- game_list
    ('遊戲列表 - 檢視',         'game_list:view',             (SELECT id FROM menus WHERE code = 'game_list'), 'view',   7, '遊戲 Tab 列表查詢', NOW()),
    ('遊戲列表 - 編輯',         'game_list:edit',             (SELECT id FROM menus WHERE code = 'game_list'), 'edit',   7, 'per-platform 啟用與購買功能 toggle', NOW()),
    ('遊戲列表 - 管理上下架',   'game_mgmt:edit',             (SELECT id FROM menus WHERE code = 'game_list'), 'edit',   1, '遊戲管理 Tab 上架／獨家／備註', NOW()),
    -- platform
    ('平台列表 - 檢視',         'platform:view',                 (SELECT id FROM menus WHERE code = 'platform'), 'view',   7, '平台列表與狀態唯讀', NOW()),
    ('平台列表 - 新增',         'platform:create',               (SELECT id FROM menus WHERE code = 'platform'), 'create', 3, '新增平台', NOW()),
    ('平台表單 - 幣別選項',     'currency_options:view',         (SELECT id FROM menus WHERE code = 'platform'), 'view',   3, '新增平台幣別下拉', NOW()),
    ('平台列表 - 編輯',         'platform:edit',                 (SELECT id FROM menus WHERE code = 'platform'), 'edit',   3, '編輯平台基本資料', NOW()),
    ('平台列表 - 合規控管',     'platform_compliance:edit',      (SELECT id FROM menus WHERE code = 'platform'), 'edit',   1, '合規控管 toggle', NOW()),
    ('平台列表 - Key 複製',     'platform_key_copy:view',        (SELECT id FROM menus WHERE code = 'platform'), 'view',   3, '複製 Private Key', NOW()),
    ('平台列表 - Key 重置',     'platform_key_reset:edit',       (SELECT id FROM menus WHERE code = 'platform'), 'edit',   3, '重置 Private Key', NOW()),
    ('平台列表 - 單一錢包設定', 'platform_wallet_setting:edit',  (SELECT id FROM menus WHERE code = 'platform'), 'edit',   3, '單一錢包設定彈窗', NOW()),
    ('平台列表 - 單一錢包測試', 'platform_wallet_test:edit',     (SELECT id FROM menus WHERE code = 'platform'), 'edit',   3, '單一錢包測試彈窗', NOW()),
    ('平台列表 - 後台顯示',     'platform_backend_visible:edit', (SELECT id FROM menus WHERE code = 'platform'), 'edit',   1, '後台顯示 toggle', NOW()),
    ('平台列表 - 線路狀態',     'platform_line_enabled:edit',    (SELECT id FROM menus WHERE code = 'platform'), 'edit',   1, '線路狀態 toggle', NOW()),
    ('平台列表 - 刪除',         'platform:delete',               (SELECT id FROM menus WHERE code = 'platform'), 'delete', 1, '刪除平台', NOW()),
    -- user
    ('使用者管理 - 檢視',       'user:view',                     (SELECT id FROM menus WHERE code = 'user'), 'view',   7, '使用者列表查詢', NOW()),
    ('使用者管理 - 新增',       'user:create',                   (SELECT id FROM menus WHERE code = 'user'), 'create', 3, '新增與複製使用者', NOW()),
    ('使用者管理 - 編輯',       'user:edit',                     (SELECT id FROM menus WHERE code = 'user'), 'edit',   3, '編輯使用者', NOW()),
    ('使用者管理 - 修改密碼',   'user_password:edit',            (SELECT id FROM menus WHERE code = 'user'), 'edit',   3, '修改既有帳號密碼（Studio／總代理）', NOW()),
    ('使用者管理 - 啟停',       'user:delete',                   (SELECT id FROM menus WHERE code = 'user'), 'delete', 3, '啟用／停用帳號 toggle', NOW()),
    -- role
    ('角色管理 - 檢視',         'role:view',                     (SELECT id FROM menus WHERE code = 'role'), 'view',   3, '角色列表查詢', NOW()),
    ('角色管理 - 新增',         'role:create',                   (SELECT id FROM menus WHERE code = 'role'), 'create', 3, '新增角色', NOW()),
    ('角色管理 - 編輯',         'role:edit',                     (SELECT id FROM menus WHERE code = 'role'), 'edit',   3, '編輯角色與功能樹', NOW()),
    ('角色管理 - 刪除',         'role:delete',                   (SELECT id FROM menus WHERE code = 'role'), 'delete', 3, '刪除角色', NOW()),
    -- currency
    ('幣別管理 - 檢視',         'currency:view',                 (SELECT id FROM menus WHERE code = 'currency'), 'view',   1, '幣別管理列表', NOW()),
    ('幣別管理 - 新增',         'currency:create',               (SELECT id FROM menus WHERE code = 'currency'), 'create', 1, '新增幣別', NOW()),
    ('幣別管理 - 編輯',         'currency:edit',                 (SELECT id FROM menus WHERE code = 'currency'), 'edit',   1, '編輯幣別與投注選項', NOW()),
    ('幣別管理 - 刪除',         'currency:delete',               (SELECT id FROM menus WHERE code = 'currency'), 'delete', 1, '刪除未使用幣別', NOW());

SELECT setval(pg_get_serial_sequence('permissions', 'id'), (SELECT COALESCE(MAX(id), 1) FROM permissions));
