-- TCG-156611: drop any legacy global-uniqueness constraint/index on
-- platform_wallet_settings' URL column. Pre-baseline-rewrite history (TCG-147031) added a
-- single-column UNIQUE constraint (uk_pws_callback_url) enforcing one callback URL per platform
-- globally; TCG-156611 v2 explicitly allows the same URL across different platforms, and the
-- current greenfield baseline never carries this constraint. Brownfield environments provisioned
-- before the baseline rewrite may still have it (possibly under Postgres's default unnamed-UNIQUE
-- name, platform_wallet_settings_callback_url_key, if that history ever ran without an explicit
-- name), so drop by both known names AND by dynamic lookup covering the current platform_url
-- column, so this is safe to (re)run regardless of which name/form exists in a given environment.
SET search_path TO gs_gss, public;

ALTER TABLE platform_wallet_settings DROP CONSTRAINT IF EXISTS uk_pws_callback_url;
ALTER TABLE platform_wallet_settings DROP CONSTRAINT IF EXISTS platform_wallet_settings_callback_url_key;

DO $$
DECLARE
    legacy_name TEXT;
BEGIN
    FOR legacy_name IN
        SELECT con.conname
        FROM pg_constraint con
        JOIN pg_class rel ON rel.oid = con.conrelid
        JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
        WHERE nsp.nspname = 'gs_gss'
          AND rel.relname = 'platform_wallet_settings'
          AND con.contype = 'u'
          AND pg_get_constraintdef(con.oid) = 'UNIQUE (platform_url)'
    LOOP
        EXECUTE format('ALTER TABLE platform_wallet_settings DROP CONSTRAINT %I', legacy_name);
    END LOOP;

    FOR legacy_name IN
        SELECT cls.relname
        FROM pg_index idx
        JOIN pg_class cls ON cls.oid = idx.indexrelid
        JOIN pg_class tbl ON tbl.oid = idx.indrelid
        JOIN pg_namespace nsp ON nsp.oid = tbl.relnamespace
        WHERE nsp.nspname = 'gs_gss'
          AND tbl.relname = 'platform_wallet_settings'
          AND idx.indisunique
          AND NOT idx.indisprimary
          AND NOT EXISTS (SELECT 1 FROM pg_constraint c WHERE c.conindid = idx.indexrelid)
          AND pg_get_indexdef(idx.indexrelid) LIKE '%(platform_url)%'
    LOOP
        EXECUTE format('DROP INDEX IF EXISTS %I', legacy_name);
    END LOOP;
END $$;
