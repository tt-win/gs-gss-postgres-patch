-- TCG-165069 ST-12: drop legacy platform-level Public Key metadata from GSS platforms table.
SET search_path TO gs_gss, public;

ALTER TABLE platforms
    DROP COLUMN IF EXISTS public_key_ready;

ALTER TABLE platforms
    DROP COLUMN IF EXISTS public_key_updated_time;
