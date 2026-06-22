-- Mirror: gac-mongo-patch scripts/v1.0.0/TP-0000/seed/tenant-seed.js
-- Source: gs-gss-server-21/src/main/resources/db/dev-seed/V2__dev_seed.sql
SET search_path TO public;

INSERT INTO tenants (id, name, code, platform_id, currency_id, status, created_time, version)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'RNG-BO 示範線路', 'tcgdemov3', 1, 2, 'active', NOW(), 0);
