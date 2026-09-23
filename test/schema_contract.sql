-- Schema contract test for gs_gss PostgreSQL patch.
SET search_path TO gs_gss;

DO $$
DECLARE
    missing text;
BEGIN
    SELECT string_agg(t, ', ')
    INTO missing
    FROM unnest(ARRAY[
        'master_agent_public_key_status',
        'game_supported_languages'
    ]) AS t
    WHERE NOT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'gs_gss' AND table_name = t
    );
    IF missing IS NOT NULL THEN
        RAISE EXCEPTION 'missing tables: %', missing;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'chk_mapks_status'
          AND conrelid = 'gs_gss.master_agent_public_key_status'::regclass
    ) THEN
        RAISE EXCEPTION 'master_agent_public_key_status status check constraint missing (TCG-165069)';
    END IF;
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss'
          AND table_name = 'platforms'
          AND column_name = 'public_key_ready'
    ) THEN
        RAISE EXCEPTION 'platforms.public_key_ready should be dropped (TCG-165069 ST-12)';
    END IF;
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'gs_gss'
          AND table_name = 'platforms'
          AND column_name = 'public_key_updated_time'
    ) THEN
        RAISE EXCEPTION 'platforms.public_key_updated_time should be dropped (TCG-165069 ST-12)';
    END IF;
END $$;

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM gs_gss.game_supported_languages) <> 38 THEN
        RAISE EXCEPTION 'game_supported_languages does not have the expected 38 seed rows (TCG-165041)';
    END IF;

    IF (SELECT COUNT(*) FROM gs_gss.game_supported_languages WHERE code IN ('CN', 'EN')) <> 2 THEN
        RAISE EXCEPTION 'game_supported_languages missing CN/EN seed rows (TCG-165041)';
    END IF;
END $$;

\echo 'schema_contract: OK'
