-- TCG-160762: platform delete becomes soft-delete.
-- Live-only name uniqueness so a deleted platform's name can be reused.
-- Keep the unique-index name platforms_name_key so GSS still maps 23505 → PLATFORM_NAME_DUPLICATE.
-- platforms.code stays a full unique constraint (deleted codes remain occupied).
SET search_path TO gs_gss, public;

ALTER TABLE platforms
    ADD COLUMN IF NOT EXISTS deleted_time TIMESTAMPTZ;

ALTER TABLE platforms DROP CONSTRAINT IF EXISTS platforms_name_key;
DROP INDEX IF EXISTS platforms_name_key;

CREATE UNIQUE INDEX IF NOT EXISTS platforms_name_key
    ON platforms (name)
    WHERE deleted_time IS NULL;
