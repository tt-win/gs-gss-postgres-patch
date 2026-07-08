-- Source: gs-gss-21/src/main/resources/db/dev-seed/V3__gss_dev_seed.sql
-- Menus: docs/GSS_REQUIRED_PERMISSIONS.md §四
SET search_path TO gs_gss, public;

INSERT INTO menus (id, code, type, parent_id, sort, icon, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1,  'home',               'page',     NULL, 1, 'home',         NOW()),
    (2,  'announcement_mgmt',  'category', NULL, 2, 'notification', NOW()),
    (5,  'game',               'category', NULL, 3, 'appstore',     NOW()),
    (7,  'player_mgmt',        'category', NULL, 4, 'team',         NOW()),
    (9,  'report_mgmt',        'category', NULL, 5, 'bar-chart',    NOW()),
    (11, 'marketing_mgmt',     'category', NULL, 6, 'gift',         NOW()),
    (14, 'platform_mgmt',      'category', NULL, 7, 'cloud',        NOW()),
    (18, 'system',             'category', NULL, 8, 'setting',      NOW()),
    (25, 'compliance',         'category', NULL, 9, 'safety',       NOW())
ON CONFLICT (id) DO UPDATE SET
    code       = EXCLUDED.code,
    type       = EXCLUDED.type,
    parent_id  = EXCLUDED.parent_id,
    sort       = EXCLUDED.sort,
    icon       = EXCLUDED.icon;

INSERT INTO menus (id, code, type, parent_id, sort, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (3,  'announcement',   'page', 2,  1, NOW()),
    (4,  'marquee',        'page', 2,  2, NOW()),
    (6,  'game_setting',   'page', 5,  1, NOW()),
    (8,  'player',         'page', 7,  1, NOW()),
    (10, 'report',         'page', 9,  1, NOW()),
    (12, 'marketing',      'page', 11, 1, NOW()),
    (13, 'payout',         'page', 11, 2, NOW()),
    (15, 'platform',       'page', 14, 1, NOW()),
    (16, 'platform_fee',   'page', 14, 2, NOW()),
    (17, 'platform_quota', 'page', 14, 3, NOW()),
    (19, 'user',           'page', 18, 1, NOW()),
    (20, 'role',           'page', 18, 2, NOW()),
    (21, 'whitelist',      'page', 18, 3, NOW()),
    (22, 'currency',       'page', 18, 4, NOW()),
    (23, 'risk',           'page', 18, 5, NOW()),
    (24, 'action_log',     'page', 18, 6, NOW()),
    (26, 'rtp',            'page', 25, 1, NOW())
ON CONFLICT (id) DO UPDATE SET
    code      = EXCLUDED.code,
    type      = EXCLUDED.type,
    parent_id = EXCLUDED.parent_id,
    sort      = EXCLUDED.sort;

SELECT setval(pg_get_serial_sequence('menus', 'id'), (SELECT COALESCE(MAX(id), 1) FROM menus));
