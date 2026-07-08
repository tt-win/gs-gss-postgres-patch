-- Source: gs-gss-21/src/main/resources/db/dev-seed/V3__gss_dev_seed.sql
SET search_path TO gs_gss, public;

INSERT INTO currency_codes (id, code, type, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'USD', 'fiat', NOW()),
    (2, 'CNY', 'fiat', NOW()),
    (3, 'EUR', 'fiat', NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO currencies (id, currency_code_id, name, active, bet_options, created_by, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 1, 'USD', true, '[0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100]'::jsonb, 0, NOW()),
    (2, 2, 'CNY', true, '[1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]'::jsonb, 0, NOW()),
    (3, 3, 'EUR', true, '[0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100]'::jsonb, 0, NOW())
ON CONFLICT (id) DO NOTHING;
