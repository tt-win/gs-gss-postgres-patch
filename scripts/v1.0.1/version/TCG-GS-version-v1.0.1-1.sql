-- Release marker: v1.0.1-TP-155509
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-1-TP-5315',
    'TCG-155509 public_key_reset_time + drop platform_key_copy:view',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
