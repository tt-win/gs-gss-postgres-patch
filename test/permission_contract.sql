-- Permission contract test for TCG-165069 Studio-only Public Key management.
SET search_path TO gs_gss;

DO $$
DECLARE
    mask SMALLINT;
    non_studio_grants INTEGER;
BEGIN
    SELECT role_type_mask INTO mask
    FROM permissions
    WHERE code = 'platform_public_key_reset:edit';

    IF mask IS NULL THEN
        RAISE EXCEPTION 'permission contract failed: platform_public_key_reset:edit missing';
    END IF;
    IF mask <> 1 THEN
        RAISE EXCEPTION 'permission contract failed: platform_public_key_reset:edit role_type_mask must be 1 (studio only), got %', mask;
    END IF;

    SELECT COUNT(*) INTO non_studio_grants
    FROM role_permissions rp
    JOIN permissions p ON p.id = rp.permission_id
    JOIN roles r ON r.id = rp.role_id
    WHERE p.code = 'platform_public_key_reset:edit'
      AND r.role_type IN ('master_agent', 'sub_account');

    IF non_studio_grants > 0 THEN
        RAISE EXCEPTION 'permission contract failed: % non-studio grant(s) remain for platform_public_key_reset:edit', non_studio_grants;
    END IF;
END $$;

\echo 'permission_contract: OK'
