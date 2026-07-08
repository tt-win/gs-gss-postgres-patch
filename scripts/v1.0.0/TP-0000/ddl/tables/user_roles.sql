-- Source: gs-gss-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT NOT NULL, -- FK → users(id), ON DELETE CASCADE
    role_id BIGINT NOT NULL, -- FK → roles(id), ON DELETE CASCADE
    created_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time TIMESTAMPTZ,
    version INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, role_id)
);

CREATE INDEX IF NOT EXISTS idx_ur_ri ON user_roles (role_id);
