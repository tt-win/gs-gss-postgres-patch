-- TCG-165069: master-agent Public Key provision/revoke saga coordination state.
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS master_agent_public_key_status (
    master_agent_id BIGINT       PRIMARY KEY,
    status          VARCHAR(20)  NOT NULL,
    operation_id    VARCHAR(128),
    updated_time    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    last_error      TEXT,
    version         INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT chk_mapks_status CHECK (status IN ('PENDING', 'READY', 'FAILED', 'REVOKED'))
);

CREATE INDEX IF NOT EXISTS idx_mapks_s
    ON master_agent_public_key_status (status);
