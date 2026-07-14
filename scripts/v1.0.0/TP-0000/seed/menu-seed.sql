-- Source: TP-5315 / TCG-147021 Phase 1 menu tree
-- Menus: docs/GSS_REQUIRED_PERMISSIONS.md §四（Phase 1 子集）
SET search_path TO gs_gss, public;

-- TP-0000 baseline owns the full menus catalog; wipe and reset id sequence
TRUNCATE menus RESTART IDENTITY;

INSERT INTO menus (code, type, parent_id, sort, icon, created_time)
VALUES
    ('system', 'category', NULL, 1, 'setting',  NOW()),
    ('game',   'category', NULL, 2, 'appstore', NOW());

INSERT INTO menus (code, type, parent_id, sort, created_time)
VALUES
    ('user',      'page', (SELECT id FROM menus WHERE code = 'system'), 1, NOW()),
    ('platform',  'page', (SELECT id FROM menus WHERE code = 'system'), 2, NOW()),
    ('currency',  'page', (SELECT id FROM menus WHERE code = 'system'), 3, NOW()),
    ('role',      'page', (SELECT id FROM menus WHERE code = 'system'), 4, NOW()),
    ('game_list', 'page', (SELECT id FROM menus WHERE code = 'game'),   1, NOW());

SELECT setval(pg_get_serial_sequence('menus', 'id'), (SELECT COALESCE(MAX(id), 1) FROM menus));
