-- Rows that existed before the dispatch-group columns were added never get them from the
-- catalog poll (that poll only inserts). Backfill the live titles; only touches rows still
-- missing a group, so re-running is harmless.
SET search_path TO gs_gss, public;

UPDATE games SET game_group_id = 4, game_group_code = 'SLOT_WAYS'
WHERE id = 3003 AND game_group_id IS NULL;

UPDATE games SET game_group_id = 7, game_group_code = 'SLOT_MEGAWAYS'
WHERE id = 3005 AND game_group_id IS NULL;

UPDATE games SET game_group_id = 5, game_group_code = 'SLOT_PAY_ANYWHERE'
WHERE id = 3006 AND game_group_id IS NULL;
