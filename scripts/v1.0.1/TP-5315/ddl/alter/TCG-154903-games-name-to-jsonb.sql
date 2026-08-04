-- TCG-154903: games.name VARCHAR -> bilingual JSONB; backfill missing CN/EN keys
SET search_path TO gs_gss, public;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'gs_gss'
          AND table_name = 'games'
          AND column_name = 'name'
          AND udt_name = 'varchar'
    ) THEN
        ALTER TABLE games
            ALTER COLUMN name TYPE JSONB
            USING jsonb_build_object('CN', name, 'EN', name);
    END IF;
END $$;

COMMENT ON COLUMN games.name IS 'Bilingual display names {"CN":"...","EN":"..."}; API resolves via locale';