-- TCG-166396: 訂單查詢 / 依單號查詢.
-- role_type_mask=7 only limits who may receive these permissions. Grants below are
-- explicit: Studio Admin, every master-agent role, and every sub-account role
-- (those roles are owned by a master agent, plus the default sub-account role).
SET search_path TO gs_gss, public;

INSERT INTO menus (code, type, parent_id, sort, icon, created_time)
SELECT 'order_query', 'category', NULL, 3, 'profile', NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'order_query');

INSERT INTO menus (code, type, parent_id, sort, created_time)
SELECT 'order_by_round', 'page', (SELECT id FROM menus WHERE code = 'order_query'), 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM menus WHERE code = 'order_by_round');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
SELECT '訂單查詢 - 檢視', 'order_query:view',
       (SELECT id FROM menus WHERE code = 'order_query'), 'view', 7,
       '訂單查詢分類頂層檢視', NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'order_query:view');

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, parent_id, created_time)
SELECT '依單號查詢 - 檢視', 'order_by_round:view',
       (SELECT id FROM menus WHERE code = 'order_by_round'), 'view', 7,
       '依遊戲局號查詢一局', (SELECT id FROM permissions WHERE code = 'order_query:view'), NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'order_by_round:view');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code IN ('order_query:view', 'order_by_round:view')
WHERE r.deleted_time IS NULL
  AND (
    r.id = 1
    OR r.role_type IN ('master_agent', 'sub_account')
  )
ON CONFLICT (role_id, permission_id) DO NOTHING;
