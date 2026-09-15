-- TCG-158901: seed action_logs purge only. game_history is intentionally omitted.
SET search_path TO gs_gss, public;

INSERT INTO purge_data_setting (
    table_name,
    purge_sequence,
    active,
    retain_days,
    date_field,
    batch_size,
    max_batches,
    max_execution_seconds,
    continue_on_error,
    created_time,
    version
) VALUES (
    'action_logs',
    10,
    TRUE,
    365,
    'created_time',
    1000,
    100,
    1200,
    TRUE,
    NOW(),
    0
)
ON CONFLICT (table_name) DO UPDATE SET
    purge_sequence        = EXCLUDED.purge_sequence,
    retain_days           = EXCLUDED.retain_days,
    date_field            = EXCLUDED.date_field,
    batch_size            = EXCLUDED.batch_size,
    max_batches           = EXCLUDED.max_batches,
    max_execution_seconds = EXCLUDED.max_execution_seconds,
    continue_on_error     = EXCLUDED.continue_on_error,
    updated_time          = NOW();
