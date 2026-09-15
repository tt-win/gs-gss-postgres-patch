-- Release marker: v1.0.1-TP-5315-2 (permission hierarchy: parent_id + system:view/game:view)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-2',
    'GS PostgreSQL patch v1.0.1-2 — TP-5315 TCG-155395 permission hierarchy (parent_id + system:view/game:view)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
