-- Source: gs-gss-server-21/src/main/resources/db/migration/V2__init.sql
SET search_path TO gs_gss, public;

CREATE TABLE user_suspensions (
    user_id              BIGINT      NOT NULL, -- FK → users(id) 被停權者, ON DELETE CASCADE
    suspended_by_user_id BIGINT      NOT NULL, -- FK → users(id) 執行停權者
    reason               TEXT,
    created_time         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_time         TIMESTAMPTZ,
    version              INTEGER     NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, suspended_by_user_id)
);

CREATE INDEX user_suspensions_suspended_by_idx ON user_suspensions (suspended_by_user_id);
