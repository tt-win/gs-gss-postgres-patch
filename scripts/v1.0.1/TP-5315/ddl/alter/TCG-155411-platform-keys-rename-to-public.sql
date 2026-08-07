-- TCG-155411: platforms.private_key_* -> public_key_* (display-name rename: this key is GS's
-- public key, used by the platform to verify wallet callback JWT signatures; never a private key).
SET search_path TO gs_gss, public;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'private_key_updated_at'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'public_key_updated_time'
    ) THEN
        ALTER TABLE platforms RENAME COLUMN private_key_updated_at TO public_key_updated_time;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'public_key_updated_at'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'public_key_updated_time'
    ) THEN
        ALTER TABLE platforms RENAME COLUMN public_key_updated_at TO public_key_updated_time;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'private_key_ready'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss' AND table_name = 'platforms' AND column_name = 'public_key_ready'
    ) THEN
        ALTER TABLE platforms RENAME COLUMN private_key_ready TO public_key_ready;
    END IF;
END $$;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS public_key_updated_time TIMESTAMPTZ;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS public_key_ready BOOLEAN NOT NULL DEFAULT true;
