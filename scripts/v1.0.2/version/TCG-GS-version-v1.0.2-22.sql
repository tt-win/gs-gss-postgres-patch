-- Release marker: v1.0.2-TP-5795-22 (TCG-166305 player list menu permissions)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-22',
    'GS PostgreSQL patch v1.0.2-22 — seed 玩家管理 / 玩家列表 permissions (TCG-166305)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
