-- TCG-156611: the platform_api_test_runs.all_passed column comment (set in the v1.0.0 baseline
-- CREATE TABLE) still describes the pre-v2 5-step flow, including Award and a separate Transfer
-- CREDIT step. v2 dropped Award and CREDIT, leaving 4 steps (GET_SESSION, GET_BALANCE, TRANSFER,
-- TRANSFER_CANCEL). The baseline file itself is a historical snapshot later alter scripts build on
-- (e.g. TCG-155682's callback_url->platform_url rename checks for the baseline's original column
-- name) and is left untouched; this only refreshes the live column comment, which COMMENT ON is
-- naturally idempotent to rerun.
SET search_path TO gs_gss, public;

COMMENT ON COLUMN platform_api_test_runs.all_passed IS
    '4 步是否全過 (GET_SESSION -> GET_BALANCE -> TRANSFER -> TRANSFER_CANCEL)';
