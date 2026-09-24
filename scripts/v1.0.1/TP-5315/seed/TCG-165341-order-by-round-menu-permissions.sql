-- TCG-165341: 訂單查詢 / 依單號查詢. role_type_mask=7 (studio|master_agent|sub_account).
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
