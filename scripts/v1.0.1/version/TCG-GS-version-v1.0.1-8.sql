-- Release marker: v1.0.1-TP-5315-8 (TCG-158901 purge data framework)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-8',
    'GS PostgreSQL patch v1.0.1-8 — TP-5315 TCG-158901 purge_data_setting/log for action_logs',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
