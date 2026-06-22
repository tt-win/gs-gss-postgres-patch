-- Mirror: gac-mongo-patch scripts/v1.0.0/TP-0000/seed/currency-seed.js
-- Source: gs-gss-server-21/src/main/resources/db/dev-seed/V2__dev_seed.sql
SET search_path TO public;

INSERT INTO currencies (id, code, status, cny_rate, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'USD', 'active', 7.23, NOW()),
    (2, 'CNY', 'active', 1.0, NOW()),
    (3, 'EUR', 'active', 7.82, NOW());
