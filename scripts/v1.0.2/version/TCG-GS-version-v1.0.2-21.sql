-- Release marker: v1.0.2-TP-5795-21 (TCG-166843 order-by-player permissions)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-21',
    'GS PostgreSQL patch v1.0.2-21 — seed 訂單查詢 / 依玩家帳號查詢 permissions (TCG-166843)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
