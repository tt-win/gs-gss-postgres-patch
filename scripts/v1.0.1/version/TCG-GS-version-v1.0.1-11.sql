-- Release marker: v1.0.1-TP-5315-11 (TCG-160985 remove platform_compliance:edit permission)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-11',
    'GS PostgreSQL patch v1.0.1-11 — TP-5315 TCG-160985 remove 合規控管 toggle permission tree node (platform_compliance:edit)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
