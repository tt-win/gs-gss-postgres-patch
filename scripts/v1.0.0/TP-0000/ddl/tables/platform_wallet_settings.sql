-- Source: gs-gss-server-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE platform_wallet_settings (
    platform_id  BIGINT       NOT NULL PRIMARY KEY, -- FK → platforms(id), ON DELETE CASCADE
    callback_url TEXT         NOT NULL UNIQUE,
    game_account VARCHAR(255) NOT NULL,
    timeout_secs INTEGER      NOT NULL DEFAULT 3,
    created_time TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_time TIMESTAMPTZ,
    version      INTEGER      NOT NULL DEFAULT 0
);
