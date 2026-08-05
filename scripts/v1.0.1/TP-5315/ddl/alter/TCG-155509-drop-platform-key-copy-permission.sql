-- TCG-155509 / TCG-154909: remove list Private Key copy permission (copy API deleted in gs-gss).
SET search_path TO gs_gss, public;

DELETE FROM role_permissions
WHERE permission_id IN (
    SELECT id FROM permissions WHERE code = 'platform_key_copy:view'
);

DELETE FROM permissions
WHERE code = 'platform_key_copy:view';
