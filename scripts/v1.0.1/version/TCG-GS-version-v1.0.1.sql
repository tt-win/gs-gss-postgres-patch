-- Release marker: v1.0.1-TP-5315 (games.name bilingual JSONB)
SET search_path TO gs_gss, public;

INSERT INTO gs_version (version, description, applied_at)
VALUES (
    'v1.0.1',
    'GS PostgreSQL patch v1.0.1 — TP-5315 TCG-154903 games.name JSONB',
    NOW()
)
ON CONFLICT (version) DO UPDATE SET
    description = EXCLUDED.description,
    applied_at  = EXCLUDED.applied_at;
