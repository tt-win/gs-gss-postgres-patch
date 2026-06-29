-- Source: gs-gss-server-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS user_accessible_platforms (
    user_id           BIGINT NOT NULL, -- FK → users(id), ON DELETE CASCADE
    platform_id       BIGINT NOT NULL, -- FK → platforms(id), ON DELETE CASCADE
    master_agent_id   BIGINT NOT NULL, -- FK → users(id) master_agent; = users.parent_id = platforms.owner_user_id
    created_time      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time      TIMESTAMPTZ,
    version           INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, platform_id)
);

CREATE INDEX IF NOT EXISTS idx_uap_pi ON user_accessible_platforms (platform_id);
CREATE INDEX IF NOT EXISTS idx_uap_mai ON user_accessible_platforms (master_agent_id);
