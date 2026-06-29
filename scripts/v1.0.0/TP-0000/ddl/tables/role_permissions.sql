-- Source: gs-gss-server-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id       BIGINT NOT NULL, -- FK → roles(id), ON DELETE CASCADE
    permission_id BIGINT NOT NULL, -- FK → permissions(id), ON DELETE CASCADE
    created_time  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time  TIMESTAMPTZ,
    version       INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (role_id, permission_id)
);
