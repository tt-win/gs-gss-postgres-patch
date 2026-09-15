-- TCG-155682: platform_wallet_settings.callback_url / platform_api_test_runs.callback_url ->
-- platform_url (naming fix: the column holds the platform's wallet API base URL, not an
-- inbound callback endpoint).
SET search_path TO gs_gss, public;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platform_wallet_settings' AND column_name = 'callback_url'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platform_wallet_settings' AND column_name = 'platform_url'
    ) THEN
        ALTER TABLE platform_wallet_settings RENAME COLUMN callback_url TO platform_url;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platform_api_test_runs' AND column_name = 'callback_url'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platform_api_test_runs' AND column_name = 'platform_url'
    ) THEN
        ALTER TABLE platform_api_test_runs RENAME COLUMN callback_url TO platform_url;
    END IF;
END $$;
