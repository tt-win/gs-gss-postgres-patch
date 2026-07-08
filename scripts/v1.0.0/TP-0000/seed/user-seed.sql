-- Source: gs-gss-21/src/main/resources/db/dev-seed/V3__gss_dev_seed.sql
-- All seed accounts use password: 1qaz@WSX
SET search_path TO gs_gss, public;

INSERT INTO users (
    id, username, email, password, nickname, user_type,
    agent_code, parent_id, last_modified_by, protected, status, created_time, version
)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'ops_admin', 'ops@example.com',
     '$2b$10$JGAQZZhRvsgo1kLlxKSWg.VZowGrnxca0Zh5OUEf2IrVC29xN0ou2',
     'Ops Admin', 'studio', NULL, NULL, NULL, true, 'active', NOW(), 0),
    (2, 'limited_ops', 'limited_ops@example.com',
     '$2b$10$nQBfsKdThoX8Gc8Jl/Xucew5N6Qn8PqsdudzRwj1PfQN7hlaUt6K6',
     'Limited Ops', 'studio', NULL, NULL, 1, false, 'active', NOW(), 0),
    (3, 'master_agent_01', 'master01@example.com',
     '$2b$10$jEip2z41j8ctGo4S0/GKLeVL.9p/PHt5HuC49eccfje682jyGdicG',
     'Master Agent 01', 'master_agent', 'MA01', NULL, 1, false, 'active', NOW(), 0)
ON CONFLICT (id) DO NOTHING;

-- Platform ID: {agent_code lowercase}_{currency_code uppercase}; sequence_no=1 when first per owner+currency
INSERT INTO platforms (
    id, code, name, owner_user_id, currency_id, wallet_type,
    compliance_enabled, backend_visible, line_enabled, sequence_no, active, created_time
)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'ma01_CNY01', 'CNY Platform', 3, 2, 'single_wallet', false, true, false, 1, true, NOW()),
    (2, 'ma01_USD01', 'Alpha Casino', 3, 1, 'single_wallet', false, true, false, 1, true, NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO users (
    id, username, email, password, nickname, user_type,
    agent_code, parent_id, last_modified_by, protected, status, created_time, version
)
OVERRIDING SYSTEM VALUE
VALUES
    (4, 'sub_master_01', 'submaster01@example.com',
     '$2b$10$dHagykXvgEOIxvpzUbFaZ.xhfZlLqQcnfzVy5Dl5tXRrCwjQNr3WK',
     'Sub Master 01', 'sub_account', NULL, 3, 1, false, 'active', NOW(), 0),
    (5, 'agent_01', 'agent01@example.com',
     '$2b$10$8GQLoD8oB2wHkhMDF8QD..81X6WXmy99OygL8xFLlTyygqSkN99se',
     'Agent 01', 'sub_account', NULL, 3, 1, false, 'active', NOW(), 0),
    (6, 'sub_agent_01', 'subagent01@example.com',
     '$2b$10$a89VV..YFiP1ZsdklTocT.fAFPzBXekogsV7y2feAeKFDvSGK2rNu',
     'Sub Agent 01', 'sub_account', NULL, 3, 1, false, 'active', NOW(), 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO user_roles (user_id, role_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 3),
    (6, 3)
ON CONFLICT (user_id, role_id) DO NOTHING;

INSERT INTO user_accessible_platforms (user_id, platform_id, master_agent_id) VALUES
    (2, 1, 3),
    (4, 1, 3),
    (5, 1, 3),
    (6, 1, 3)
ON CONFLICT (user_id, platform_id) DO NOTHING;

INSERT INTO games (
    id, game_code, name, game_type, active, has_ever_listed,
    supports_freegame, supports_bonusgame, created_time
)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'DEMO01', 'Demo Slot Game', 'slot', true, true, true, false, NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO platform_games (platform_id, game_id, active, freegame_enabled, bonusgame_enabled, created_time)
VALUES
    (1, 1, true, true, false, NOW())
ON CONFLICT (platform_id, game_id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('users', 'id'), (SELECT COALESCE(MAX(id), 1) FROM users));
SELECT setval(pg_get_serial_sequence('platforms', 'id'), (SELECT COALESCE(MAX(id), 1) FROM platforms));
SELECT setval(pg_get_serial_sequence('games', 'id'), (SELECT COALESCE(MAX(id), 1) FROM games));
