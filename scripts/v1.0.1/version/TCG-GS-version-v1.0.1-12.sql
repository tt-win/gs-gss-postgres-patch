-- Release marker: v1.0.1-TP-5315-12 (platforms soft-delete)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-12',
    'GS PostgreSQL patch v1.0.1-12 — platforms.deleted_time + live-only unique name (TCG-160762)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
