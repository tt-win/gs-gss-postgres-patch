-- Source: gs-gss-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS gs_version (
    version      VARCHAR(50) PRIMARY KEY,
    description  TEXT,
    applied_at   TIMESTAMPTZ NOT NULL,
    created_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time TIMESTAMPTZ
);
