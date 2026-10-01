-- TCG-166843: 訂單查詢 / 依玩家帳號查詢.
-- Requires TCG-166396 (order_query category + order_by_round page).
-- role_type_mask=7 only limits who may receive these permissions. Grants below are
-- explicit: Studio Admin, every master-agent role, and every sub-account role.
SET search_path TO gs_gss, public;

INSERT INTO menus (code, type, parent_id, sort, created_time)
SELECT 'order_by_player', 'page', (SELECT id FROM menus WHERE code = 'order_query'), 2, NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'order_by_player');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, parent_id, created_time)
SELECT '依玩家帳號查詢 - 檢視', 'order_by_player:view',
       (SELECT id FROM menus WHERE code = 'order_by_player'), 'view', 7,
       '依平台玩家 ID 查詢注單', (SELECT id FROM permissions WHERE code = 'order_query:view'), NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'order_by_player:view');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code IN ('order_by_player:view')
WHERE r.deleted_time IS NULL
  AND (
    r.id = 1
    OR r.role_type IN ('master_agent', 'sub_account')
  )
ON CONFLICT (role_id, permission_id) DO NOTHING;
