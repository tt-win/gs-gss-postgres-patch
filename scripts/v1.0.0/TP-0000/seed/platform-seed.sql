-- Mirror: gac-mongo-patch scripts/v1.0.0/TP-0000/seed/platform-seed.js
-- Source: gs-gss-server-21/src/main/resources/db/dev-seed/V2__dev_seed.sql
SET search_path TO gs_gss, public;

INSERT INTO platforms (id, name, code, domain_suffix, status, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'TCG',          'TCG', 'tcg.com',   'active', NOW()),
    (2, 'Alpha Casino', 'ALF', 'alpha.com', 'active', NOW());
