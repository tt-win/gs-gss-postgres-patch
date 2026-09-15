-- TCG-158331: remove legacy order menu and permissions (GSS no longer exposes order APIs).
-- Phase 1 TP-0000 seed never included order rows; this cleans brownfield DBs that still carry
-- Node-era catalog entries. Idempotent — safe to re-run.
--
-- Post-deploy (with gs-gss-21 same release): flush Redis permission cache so sessions drop retired order:* slugs:
--   DEL GS:GSS:USER_PERMISSIONS:*
-- Without flush, cached slugs may still appear in role UI until re-login.
SET search_path TO gs_gss, public;

UPDATE permissions
SET parent_id = NULL,
    updated_time = NOW()
WHERE parent_id IN (
    SELECT id FROM permissions WHERE code IN ('order:view', 'order:export', 'order:detail')
);

DELETE FROM role_permissions
WHERE permission_id IN (
    SELECT id FROM permissions WHERE code IN ('order:view', 'order:export', 'order:detail')
);

DELETE FROM permissions
WHERE code IN ('order:view', 'order:export', 'order:detail');

DELETE FROM menus
WHERE code = 'order';
