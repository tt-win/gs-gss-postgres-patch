-- TCG-166305: 玩家管理 / 玩家列表.
-- role_type_mask=7 only limits who may receive these permissions. Grants below are
-- explicit: Studio Admin, every master-agent role, and every sub-account role
-- (those roles are owned by a master agent, plus the default sub-account role).
SET search_path TO gs_gss, public;

INSERT INTO menus (code, type, parent_id, sort, icon, created_time)
SELECT 'player', 'category', NULL, 4, 'team', NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'player');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
SELECT '玩家管理 - 檢視', 'player:view',
       (SELECT id FROM menus WHERE code = 'player'), 'view', 7,
       '查詢玩家清單', NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player:view');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, parent_id, created_time)
SELECT '玩家管理 - 匯出', 'player:export',
       (SELECT id FROM menus WHERE code = 'player'), 'export', 7,
       '匯出玩家列表 CSV', (SELECT id FROM permissions WHERE code = 'player:view'), NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player:export');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code IN ('player:view', 'player:export')
WHERE r.deleted_time IS NULL
  AND (
    r.id = 1
    OR r.role_type IN ('master_agent', 'sub_account')
  )
ON CONFLICT (role_id, permission_id) DO NOTHING;
