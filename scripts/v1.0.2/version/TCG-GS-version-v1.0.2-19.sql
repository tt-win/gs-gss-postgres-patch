-- Release marker: v1.0.2-TP-5795-19 (GME supports sync audit trail)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-19',
    'GS PostgreSQL patch v1.0.2-19 — game_supports_history (TCG-166594)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
