-- Source: gs-gss-21/src/main/resources/db/dev-seed/V2__phase1_dev_seed.sql
SET search_path TO gs_gss, public;

INSERT INTO menus (id, code, type, parent_id, sort, icon, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'system', 'category', NULL, 1, 'setting', NOW()),
    (2, 'backend', 'category', NULL, 2, 'team', NOW()),
    (3, 'account', 'category', NULL, 3, 'user', NOW()),
    (4, 'game', 'category', NULL, 4, 'appstore', NOW()),
    (5, 'announcement', 'category', NULL, 5, 'notification', NOW()),
    (6, 'operation', 'category', NULL, 6, 'bar-chart', NOW())
ON CONFLICT (id) DO UPDATE;

INSERT INTO menus (id, code, type, parent_id, sort, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (7, 'currency', 'page', 1, 1, NOW()),
    (8, 'platform', 'page', 1, 2, NOW()),
    (9, 'role', 'page', 1, 3, NOW()),
    (10, 'operator', 'page', 1, 4, NOW()),
    (11, 'action_log', 'page', 1, 5, NOW()),
    (12, 'game_template', 'page', 1, 6, NOW()),
    (13, 'game_switch', 'page', 1, 7, NOW()),
    (14, 'master_agent', 'page', 2, 1, NOW()),
    (15, 'agent', 'page', 2, 2, NOW()),
    (16, 'game_setting', 'page', 2, 3, NOW()),
    (17, 'rtp_reset', 'page', 2, 4, NOW()),
    (18, 'rtp_data', 'page', 2, 5, NOW()),
    (19, 'tenant', 'page', 2, 6, NOW()),
    (20, 'user', 'page', 2, 7, NOW()),
    (21, 'my_agent', 'page', 3, 1, NOW()),
    (22, 'sub_account', 'page', 3, 2, NOW()),
    (23, 'my_role', 'page', 3, 3, NOW()),
    (24, 'player', 'page', 3, 4, NOW()),
    (25, 'game_list', 'page', 4, 1, NOW()),
    (26, 'marquee', 'page', 5, 1, NOW()),
    (27, 'order', 'page', 6, 1, NOW()),
    (28, 'round', 'page', 6, 2, NOW()),
    (29, 'whitelist', 'page', 6, 3, NOW()),
    (30, 'download', 'page', 6, 4, NOW())
ON CONFLICT (id) DO UPDATE;
