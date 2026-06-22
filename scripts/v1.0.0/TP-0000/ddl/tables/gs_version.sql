-- Mirror: gac-mongo-patch scripts/v1.0.0/TP-0000/ddl/collections/gac_version.js
-- Source: gs-gss-server-21/src/main/resources/db/migration/V1__init.sql (patch version tracking)
SET search_path TO public;

CREATE TABLE gs_version (
    version     VARCHAR(50) PRIMARY KEY,
    description TEXT,
    applied_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
