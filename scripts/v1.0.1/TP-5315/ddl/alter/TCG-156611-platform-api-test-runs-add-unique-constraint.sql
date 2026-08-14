-- TCG-156611: back PlatformApiTestRunEntity's already-declared uk_patr_platform_callback_url
-- unique constraint (platform_id, platform_url) with an actual DB constraint. The entity has
-- declared @Table(uniqueConstraints = @UniqueConstraint(name = "uk_patr_platform_callback_url",
-- columnNames = {"platform_id", "platform_url"})) since TCG-147032, but no patch ever created it —
-- nothing at the DB level stops a concurrent request or a retried write from producing more than
-- one row per (platform_id, platform_url), which is what PlatformApiTestRunService's "official last
-- result" lookup assumes is unique.
SET search_path TO gs_gss, public;

-- Drop pre-existing duplicates first (keep only the most recently created row per
-- platform_id/platform_url) so the constraint below can actually be added.
DELETE FROM platform_api_test_runs t
USING (
    SELECT id, ROW_NUMBER() OVER (
        PARTITION BY platform_id, platform_url ORDER BY created_time DESC, id DESC
    ) AS rn
    FROM platform_api_test_runs
) dup
WHERE t.id = dup.id AND dup.rn > 1;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint con
        JOIN pg_class rel ON rel.oid = con.conrelid
        JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
        WHERE nsp.nspname = 'gs_gss' AND rel.relname = 'platform_api_test_runs'
          AND con.conname = 'uk_patr_platform_callback_url'
    ) THEN
        ALTER TABLE platform_api_test_runs
            ADD CONSTRAINT uk_patr_platform_callback_url UNIQUE (platform_id, platform_url);
    END IF;
END $$;
