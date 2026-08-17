-- TCG-157823: one currency_codes row per (code, type); many currencies may share it.
-- Drop currencies.currency_code_id UNIQUE first — otherwise the merge UPDATE fails
-- when two currencies already point at cloned catalog rows.
SET search_path TO gs_gss, public;

ALTER TABLE currencies DROP CONSTRAINT IF EXISTS idx_c_cci;
ALTER TABLE currencies DROP CONSTRAINT IF EXISTS currencies_currency_code_id_key;

UPDATE currencies c
SET currency_code_id = keeper.id
FROM currency_codes cc
JOIN (
    SELECT MIN(id) AS id, code, type
    FROM currency_codes
    GROUP BY code, type
) keeper ON keeper.code = cc.code AND keeper.type = cc.type
WHERE c.currency_code_id = cc.id
  AND c.currency_code_id IS DISTINCT FROM keeper.id;

DELETE FROM currency_codes cc
WHERE cc.id NOT IN (
    SELECT MIN(id) FROM currency_codes GROUP BY code, type
);

ALTER TABLE currency_codes
    DROP CONSTRAINT IF EXISTS currency_codes_code_type_key;
ALTER TABLE currency_codes
    ADD CONSTRAINT currency_codes_code_type_key UNIQUE (code, type);
