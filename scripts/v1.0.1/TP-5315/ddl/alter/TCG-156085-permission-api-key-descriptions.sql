-- TCG-156085: clarify platform_key_* permission copy/description = API Key (not Private Key)
-- Codes unchanged; seed left as historical baseline — existing DBs updated here.
SET search_path TO gs_gss, public;

UPDATE permissions
SET name = '平台列表 - API Key 複製',
    description = '複製 API Key',
    updated_time = NOW()
WHERE code = 'platform_key_copy:view'
  AND (description IS DISTINCT FROM '複製 API Key'
       OR name IS DISTINCT FROM '平台列表 - API Key 複製');

UPDATE permissions
SET name = '平台列表 - API Key 重置',
    description = '重置 API Key',
    updated_time = NOW()
WHERE code = 'platform_key_reset:edit'
  AND (description IS DISTINCT FROM '重置 API Key'
       OR name IS DISTINCT FROM '平台列表 - API Key 重置');
