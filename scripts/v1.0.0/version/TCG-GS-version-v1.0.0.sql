-- Mirror: gac-mongo-patch scripts/v1.0.0/version/TCG-GAC-version-v1.0.0.js
-- Release marker: v1.0.0-TP-0000 (gs_gss baseline)
SET search_path TO public;

INSERT INTO gs_version (version, description, applied_at)
VALUES (
    'v1.0.0',
    'Initial baseline version',
    NOW()
)
ON CONFLICT (version) DO UPDATE SET
    description = EXCLUDED.description,
    applied_at  = EXCLUDED.applied_at;
