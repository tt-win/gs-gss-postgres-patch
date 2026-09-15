-- Release marker: v1.0.1-TP-5315-10 (games.game_group_id / game_group_code)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-10',
    'GS PostgreSQL patch v1.0.1-10 — games carry the dispatch group (game_group_id / game_group_code) for game-server dispatch sync; backfill live titles',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
