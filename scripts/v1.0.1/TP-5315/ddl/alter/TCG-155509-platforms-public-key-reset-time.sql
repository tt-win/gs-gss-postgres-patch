-- TCG-155509: track Public Key last reset/create time for platform list.
SET search_path TO gs_gss, public;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS public_key_reset_time TIMESTAMPTZ;

UPDATE platforms
SET public_key_reset_time = created_time
WHERE public_key_reset_time IS NULL;

COMMENT ON COLUMN platforms.public_key_reset_time IS
    'Last Public Key generation time (platform create or key reset); list sort/display';
