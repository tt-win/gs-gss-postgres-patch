-- games gains the dispatch group: which engine family runs the title (id + code as the game
-- catalog reports them). Filled for new rows by the GME catalog poll; the game server reads
-- it back through GET /api/setting/games to build its own dispatch table.
SET search_path TO gs_gss, public;

ALTER TABLE games ADD COLUMN IF NOT EXISTS game_group_id   INTEGER;
ALTER TABLE games ADD COLUMN IF NOT EXISTS game_group_code VARCHAR(64);

COMMENT ON COLUMN games.game_group_id   IS 'Dispatch group id — engine family that runs this title';
COMMENT ON COLUMN games.game_group_code IS 'Dispatch group code (SLOT_WAYS / SLOT_MEGAWAYS / SLOT_PAY_ANYWHERE / SLOT_LINES / SLOT_CLUSTER)';
