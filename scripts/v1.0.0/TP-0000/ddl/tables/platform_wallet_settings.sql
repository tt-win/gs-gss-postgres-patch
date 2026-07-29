-- Source: gs-gss-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS platform_wallet_settings (
    platform_id  BIGINT       NOT NULL PRIMARY KEY, -- FK → platforms(id), ON DELETE CASCADE
    callback_url VARCHAR(500) NOT NULL, -- single_wallet only; currently-saved Callback URL (TCG-147031 writes it)
    created_time TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_time TIMESTAMPTZ,
    version      INTEGER      NOT NULL DEFAULT 0
);
