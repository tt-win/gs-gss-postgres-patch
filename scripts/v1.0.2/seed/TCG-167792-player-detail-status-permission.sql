-- TCG-167792: 玩家詳細資料彈窗 / 帳號停用啟用.
-- No new menu/page — action lives under the existing player_list page (TCG-166305).
-- role_type_mask=1 (bit0=studio only, see permissions.role_type_mask comment in
-- TP-0000/ddl/tables/permissions.sql) restricts who may even be granted this
-- permission to Studio, per spec "僅 Studio人員" (cf. TCG-165069 studio-only precedent).
-- Grant below is limited to Studio Admin (r.id = 1) only — unlike TCG-166305/TCG-166843,
-- master_agent and sub_account are deliberately excluded.
SET search_path TO gs_gss, public;

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
SELECT '玩家管理 - 停用/啟用', 'player_status:edit',
       (SELECT id FROM menus WHERE code = 'player_list'), 'edit', 1,
       '玩家詳細資料彈窗的帳號停用/啟用', NOW()
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE code = 'player_status:edit');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p ON p.code = 'player_status:edit'
WHERE r.deleted_time IS NULL AND r.id = 1   -- Studio Admin 預設角色
ON CONFLICT (role_id, permission_id) DO NOTHING;
