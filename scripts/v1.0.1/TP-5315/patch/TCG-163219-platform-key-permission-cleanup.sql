-- TCG-163219: drop the copy-key permission entirely; rename the reset slug off "api_key".
--
-- Ships with gs-gss-21 same release. Post-deploy: DEL GS:GSS:USER_PERMISSIONS:*
-- so sessions pick up the removed copy node and the renamed reset slug (cached
-- 'platform_api_key_reset:edit' would otherwise fail @PreAuthorize -> 403 until re-login).
--
-- The TP-0000 baseline seed stays frozen (repo convention: all catalog changes go
-- through v1.0.1 patches), so this runs after the baseline and converges greenfield
-- rebuilds and brownfield upgrades alike. Idempotent — safe to re-run:
--   (a) copy already deleted -> DELETE no-op
--   (b) reset slug already renamed -> UPDATE hits 0 rows
--
-- 'platform_key_reset:edit' is the pre-TCG-154902 slug; its meaning is now correct
-- and it matches the platform_public_key_reset:edit naming family.
SET search_path TO gs_gss, public;

-- (a) remove copy permission — item ceases to exist, not disabled (Scenario 21)
DELETE FROM role_permissions
WHERE permission_id IN (SELECT id FROM permissions WHERE code = 'platform_api_key_copy:view');

DELETE FROM permissions WHERE code = 'platform_api_key_copy:view';

-- (b) rename reset slug + display text
UPDATE permissions
SET code = 'platform_key_reset:edit',
    name = '平台列表 - Platform Key 重置',
    description = '重置 Platform Key',
    updated_time = NOW()
WHERE code = 'platform_api_key_reset:edit';
