-- TCG-147032: platform_api_test_runs schema for connection-test persistence (C-3 + unique key).
-- game_account: which gameAccount the step_results belong to; NULL legacy rows reset on next test.
-- uk_patr_platform_callback_url: one row per (platform_id, callback_url) for upsert/retry semantics.
SET search_path TO gs_gss, public;

ALTER TABLE platform_api_test_runs
    ADD COLUMN IF NOT EXISTS game_account VARCHAR(50);

CREATE UNIQUE INDEX IF NOT EXISTS uk_patr_platform_callback_url
    ON platform_api_test_runs (platform_id, callback_url);
