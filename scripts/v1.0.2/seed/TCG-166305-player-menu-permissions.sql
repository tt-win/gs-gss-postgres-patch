-- TCG-166305: 玩家管理 / 玩家列表.
-- Category + page split mirrors game/game_list (TP-0000) and order_query/order_by_round
-- (TCG-166396): 'player' category owns the top-level player:view gate, 'player_list' page
-- owns the actually-enforced player_list:view / player_list:export permissions.
-- role_type_mask=7 only limits who may receive these permissions. Grants below are
-- explicit: Studio Admin, every master-agent role, and every sub-account role
-- (those roles are owned by a master agent, plus the default sub-account role).
SET search_path TO gs_gss, public;

INSERT INTO menus (code, type, parent_id, sort, icon, created_time)
SELECT 'player', 'category', NULL, 4, 'team', NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'player');

INSERT INTO menus (code, type, parent_id, sort, created_time)
SELECT 'player_list', 'page', (SELECT id FROM menus WHERE code = 'player'), 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'player_list');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
SELECT '玩家管理 - 檢視', 'player:view',
       (SELECT id FROM menus WHERE code = 'player'), 'view', 7,
       '玩家管理分類頂層檢視', NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player:view');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, parent_id, created_time)
SELECT '玩家列表 - 檢視', 'player_list:view',
       (SELECT id FROM menus WHERE code = 'player_list'), 'view', 7,
       '查詢玩家清單', (SELECT id FROM permissions WHERE code = 'player:view'), NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player_list:view');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, parent_id, created_time)
SELECT '玩家列表 - 匯出', 'player_list:export',
       (SELECT id FROM menus WHERE code = 'player_list'), 'export', 7,
       '匯出玩家列表 CSV', (SELECT id FROM permissions WHERE code = 'player_list:view'), NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player_list:export');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code IN ('player:view', 'player_list:view', 'player_list:export')
WHERE r.deleted_time IS NULL
  AND (
    r.id = 1
    OR r.role_type IN ('master_agent', 'sub_account')
  )
ON CONFLICT (role_id, permission_id) DO NOTHING;
