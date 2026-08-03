-- Release marker: v1.0.1-TP-154903 (games.name JSONB)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (version, description, applied_at)
VALUES (
    'v1.0.1',
    'TCG-154903: migrate games.name to JSONB localized names',
    NOW()
)
ON CONFLICT (version) DO UPDATE SET
    description = EXCLUDED.description,
    applied_at  = EXCLUDED.applied_at;
