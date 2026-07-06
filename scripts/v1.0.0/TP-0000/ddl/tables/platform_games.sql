-- Source: gs-gss-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS platform_games (
    platform_id       BIGINT      NOT NULL, -- FK → platforms(id), ON DELETE CASCADE
    game_id           BIGINT      NOT NULL, -- FK → games(id)
    active            BOOLEAN     NOT NULL DEFAULT false,
    freegame_enabled  BOOLEAN     NOT NULL DEFAULT false,
    bonusgame_enabled BOOLEAN     NOT NULL DEFAULT false,
    created_time      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time      TIMESTAMPTZ,
    version           INTEGER     NOT NULL DEFAULT 0,
    PRIMARY KEY (platform_id, game_id)
);

CREATE INDEX IF NOT EXISTS idx_pg_gi_pi ON platform_games (game_id, platform_id);
