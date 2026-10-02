-- Release marker: v1.0.2-TP-5795-23 (TCG-167792 player detail status permission)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-23',
    'GS PostgreSQL patch v1.0.2-23 — seed 玩家詳細資料彈窗 / 帳號停用啟用 permission (TCG-167792)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
