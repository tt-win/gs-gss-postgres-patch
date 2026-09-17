-- TCG-165069: restrict Public Key management to Studio role only.
--
-- Post-deploy (with gs-gss-21 same release): flush Redis permission cache:
--   DEL GS:GSS:USER_PERMISSIONS:*
-- Without flush, master_agent sessions may retain cached platform_public_key_reset:edit
-- until re-login; backend role checks still reject non-Studio callers.
SET search_path TO gs_gss, public;

UPDATE permissions
SET role_type_mask = 1,
    name = '平台管理 - Public Key 管理',
    description = '查看、複製與重置總代理 Public Key',
    updated_time = NOW()
WHERE code = 'platform_public_key_reset:edit';

DELETE FROM role_permissions rp
USING permissions p, roles r
WHERE rp.permission_id = p.id
  AND rp.role_id = r.id
  AND p.code = 'platform_public_key_reset:edit'
  AND r.role_type IN ('master_agent', 'sub_account');
