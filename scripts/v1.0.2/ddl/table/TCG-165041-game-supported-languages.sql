-- TCG-165041: 遊戲支援語系清單（純 seed 資料表，無維護 UI；異動靠後續 patch）
-- code 非固定兩碼慣例——清單含 UR-LA、PT-BR 等連字號代碼，故放寬為 VARCHAR(10)
SET search_path TO gs_gss, public;

CREATE TABLE IF NOT EXISTS game_supported_languages (
    code         VARCHAR(10)  PRIMARY KEY,
    sort_order   INTEGER      NOT NULL DEFAULT 0,
    created_time TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE game_supported_languages IS
    '遊戲名稱多語系設定的可選語系清單（TCG-165041）；獨立於後台介面語系，'
    '通常語系數更多；本單不提供維護介面，異動靠後續 DB patch 直接 INSERT/DELETE';
