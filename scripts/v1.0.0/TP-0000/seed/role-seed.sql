-- Source: gs-gss-21/src/main/resources/db/dev-seed/V2__phase1_dev_seed.sql
SET search_path TO gs_gss, public;

INSERT INTO roles (id, name, description, role_type, protected, active, owner_user_id, created_time)
OVERRIDING SYSTEM VALUE
VALUES
    (1, 'Admin',  'System Administrator with full access', 'studio',       true,  true, NULL, NOW()),
    (2, 'Editor', 'Content Editor',                        'master_agent', false, true, NULL, NOW()),
    (3, 'Viewer', 'Read-only access',                      'master_agent', false, true, NULL, NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id) VALUES
    (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 10),
    (2, 11), (2, 12), (2, 13), (2, 15), (2, 16), (2, 17), (2, 18), (2, 19),
    (2, 21), (2, 22), (2, 23), (2, 24), (2, 25), (2, 27), (2, 28), (2, 29),
    (2, 30), (2, 31), (2, 32), (2, 33), (2, 34), (2, 36), (2, 37), (2, 38),
    (2, 39), (2, 40), (2, 41), (2, 42), (2, 44), (2, 45), (2, 46), (2, 47),
    (2, 48), (2, 49), (2, 51), (2, 52), (2, 53), (2, 54), (2, 55), (2, 56),
    (2, 57), (2, 58), (2, 60)
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id) VALUES
    (3, 1), (3, 4), (3, 10), (3, 11), (3, 16), (3, 17), (3, 21), (3, 23),
    (3, 27), (3, 30), (3, 31), (3, 32), (3, 38), (3, 39), (3, 40), (3, 44),
    (3, 45), (3, 46), (3, 47), (3, 51), (3, 55), (3, 56), (3, 60)
ON CONFLICT (role_id, permission_id) DO NOTHING;
