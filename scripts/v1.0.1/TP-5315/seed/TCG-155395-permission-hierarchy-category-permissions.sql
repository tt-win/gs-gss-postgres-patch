-- TP-5315: add system:view / game:view category-level permissions, aligned with the
-- 'system' and 'game' category menus in menu-seed.sql. role_type_mask=7 (ALL) because it
-- must be at least the union of every descendant's mask (see design spec §1) so a role type
-- that can already be granted a descendant is never blocked from also getting this ancestor.
SET search_path TO gs_gss, public;

INSERT INTO permissions (name, code, menu_id, action, role_type_mask, description, created_time)
VALUES
    ('系統 - 檢視', 'system:view', (SELECT id FROM menus WHERE code = 'system'), 'view', 7, '系統分類的頂層檢視權限', NOW()),
    ('遊戲 - 檢視', 'game:view',   (SELECT id FROM menus WHERE code = 'game'),   'view', 7, '遊戲分類的頂層檢視權限', NOW())
ON CONFLICT (code) DO NOTHING;
