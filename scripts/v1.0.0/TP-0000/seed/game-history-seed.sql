-- Source: TP-5315 / backfill game_history from existing games.active
-- 為已存在的 games 補一筆初始紀錄；previous_active 與 active 皆取現況，不捏造變更過程。
-- 可重跑：已有紀錄的 game_id 會略過。
SET search_path TO gs_gss, public;

INSERT INTO game_history (game_id, previous_active, active, user_id, created_time, version)
SELECT
    g.id,
    g.active,                                    -- 無歷史可考，與 active 相同
    g.active,
    NULL,                                        -- backfill 無操作者
    COALESCE(g.updated_time, g.created_time),    -- 事件時間取遊戲最後更新或建立時間
    0
FROM games g
WHERE NOT EXISTS (
    SELECT 1 FROM game_history gh WHERE gh.game_id = g.id
);
