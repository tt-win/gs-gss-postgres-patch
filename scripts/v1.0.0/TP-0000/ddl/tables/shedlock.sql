-- Source: gs-gss-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS shedlock (
    name         VARCHAR(64)  NOT NULL,
    lock_until   TIMESTAMP    NOT NULL,
    locked_at    TIMESTAMP    NOT NULL,
    locked_by    VARCHAR(255) NOT NULL,
    created_time TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_time TIMESTAMPTZ,
    version      INTEGER      NOT NULL DEFAULT 0,
    PRIMARY KEY (name)
);
