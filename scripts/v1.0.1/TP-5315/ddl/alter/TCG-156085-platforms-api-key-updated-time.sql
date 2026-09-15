-- TCG-156085: platform API Key list sort / display time (gss metadata only)
SET search_path TO gs_gss, public;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS api_key_updated_time TIMESTAMPTZ;
