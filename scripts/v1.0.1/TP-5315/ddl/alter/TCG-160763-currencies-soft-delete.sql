-- TCG-160763: currency delete becomes soft-delete.
-- Code stays full-table unique (idx_c_c) so deleted codes remain permanently occupied.
SET search_path TO gs_gss, public;

ALTER TABLE currencies
    ADD COLUMN IF NOT EXISTS deleted_time TIMESTAMPTZ;
