SET search_path TO gs_gss, public;

-- Idempotent-ish: only convert when column is still text/varchar
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'gs_gss'
      AND table_name = 'games'
      AND column_name = 'name'
      AND data_type IN ('character varying', 'text')
  ) THEN
    ALTER TABLE games
      ALTER COLUMN name TYPE jsonb
      USING jsonb_build_object('CN', name, 'EN', name);
  END IF;
END $$;
