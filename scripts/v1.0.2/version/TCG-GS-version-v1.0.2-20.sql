-- Release marker: v1.0.2-TP-5795-20 (TCG-165341 order-by-round permissions)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-20',
    'GS PostgreSQL patch v1.0.2-20 — seed 訂單查詢 / 依單號查詢 permissions (TCG-165341)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
