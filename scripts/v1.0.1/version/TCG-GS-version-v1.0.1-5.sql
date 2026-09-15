-- Release marker: v1.0.1-TP-5315-5 (platform_wallet_settings/platform_api_test_runs callback_url -> platform_url;
-- TCG-156611 compliance-review follow-ups)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (db_version, build_number, description, created_time, updated_time)
VALUES (
    'v1.0.1',
    'v1.0.1-TP-5315-5',
    'GS PostgreSQL patch v1.0.1-5 — TP-5315 TCG-155682 wallet callback_url -> platform_url; '
        || 'TCG-156611 drop legacy platform_wallet_settings callback URL uniqueness; '
        || 'add missing platform_api_test_runs unique constraint',
    NOW(),
    NOW()
)
ON CONFLICT (build_number) DO UPDATE SET
    db_version   = EXCLUDED.db_version,
    description  = EXCLUDED.description,
    updated_time = EXCLUDED.updated_time;
