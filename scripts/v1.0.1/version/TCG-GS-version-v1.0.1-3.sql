-- Release marker: v1.0.1-TP-5315-3 (platforms.private_key_* renamed to public_key_*)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-3',
    'GS PostgreSQL patch v1.0.1-3 — TP-5315 TCG-155411 platforms private_key_* -> public_key_*',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
