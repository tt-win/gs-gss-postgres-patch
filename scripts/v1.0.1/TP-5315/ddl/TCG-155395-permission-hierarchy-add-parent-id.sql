-- TP-5315: add permissions.parent_id for the permission hierarchy (parent-child) feature.
SET search_path TO gs_gss, public;

ALTER TABLE permissions
    ADD COLUMN IF NOT EXISTS parent_id BIGINT; -- FK → permissions(id)
