-- TCG-163219: platforms.api_key_updated_time -> platform_key_updated_time
-- The long-term shared signing key is 'Platform Key' in the v2 integration spec;
-- the per-request api-key is now a computed MD5 signature, a different thing.
-- Guarded rename (per TCG-155411): re-runnable, converges greenfield/brownfield.
SET search_path TO gs_gss, public;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema = 'gs_gss' AND table_name = 'platforms'
                 AND column_name = 'api_key_updated_time')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema = 'gs_gss' AND table_name = 'platforms'
                 AND column_name = 'platform_key_updated_time') THEN
        ALTER TABLE platforms RENAME COLUMN api_key_updated_time TO platform_key_updated_time;
    END IF;
END $$;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS platform_key_updated_time TIMESTAMPTZ;
