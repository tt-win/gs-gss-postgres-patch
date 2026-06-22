-- Source: gs-gss-server-21/src/main/resources/db/migration/V1__init.sql
-- ShedLock distributed scheduler table (Spring infrastructure; not in gac-mongo-patch)
SET search_path TO gs_gss, public;

CREATE TABLE shedlock (
    name       VARCHAR(64)  NOT NULL,
    lock_until TIMESTAMP    NOT NULL,
    locked_at  TIMESTAMP    NOT NULL,
    locked_by  VARCHAR(255) NOT NULL,
    PRIMARY KEY (name)
);
