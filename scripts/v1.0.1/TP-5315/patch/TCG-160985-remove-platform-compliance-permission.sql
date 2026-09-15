-- TCG-160985: remove the 合規控管 (compliance) toggle and its permission tree node.
-- Phase 1 never wired compliance to any business effect; the node only ever gated a
-- no-op toggle. This drops the permission slug + every role grant of it.
-- The TP-0000 baseline seed stays frozen (repo convention: all catalog changes go
-- through v1.0.1 patches), so this runs after the baseline in the release chain and
-- converges greenfield rebuilds and brownfield upgrades alike. Idempotent — safe to re-run.
--
-- platform_compliance:edit is a leaf action node (nothing has it as parent_id), so no
-- parent re-link is needed — unlike TCG-158331 which removed a parent menu.
--
-- Session handling (TCG-160985 Scenario 7): this is a deliberate exception to the
-- "permission config changed -> clear that role's sessions" rule. Do NOT flush the
-- Redis permission cache (DEL GS:GSS:USER_PERMISSIONS:*) and do NOT force re-login.
-- The removed slug has zero UI/backend effect, so a lingering cached copy is harmless;
-- logged-in users pick up the node's absence on their next page load.
SET search_path TO gs_gss, public;

DELETE FROM role_permissions
WHERE permission_id IN (SELECT id FROM permissions WHERE code = 'platform_compliance:edit');

DELETE FROM permissions
WHERE code = 'platform_compliance:edit';
