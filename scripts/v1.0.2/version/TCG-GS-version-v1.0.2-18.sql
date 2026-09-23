-- Release marker: v1.0.2-TP-5795-18 (game name i18n supported-language seed)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.2',
    'v1.0.2-TP-5795-18',
    'GS PostgreSQL patch v1.0.2-18 — game_supported_languages seed table (TCG-165041)',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
