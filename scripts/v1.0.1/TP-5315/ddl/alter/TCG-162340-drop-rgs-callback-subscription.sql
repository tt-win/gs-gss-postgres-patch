-- TCG-162340: drop unused SPM callback URL registry.
-- Writers/readers were removed when settings/session events moved to Kafka (TCG-159760).
SET search_path TO gs_gss, public;

DROP TABLE IF EXISTS rgs_callback_subscription;
