-- /*developer permissions - all access*/
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mustream_schm TO developer;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO developer;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO developer;
-- grant usage on schema mustream_schm to developer;
--
-- /*management permissions -
--   allow: read, update, insert
--   revoke: delete, create, drop*/
-- -- grant SELECT, INSERT, and UPDATE, but prevent DELETE and CREATE/DROP
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA mustream_schm TO management;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO management;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO management;
-- -- revoke DELETE and CREATE/DROP permissions
-- REVOKE DELETE ON ALL TABLES IN SCHEMA mustream_schm FROM management;
-- REVOKE CREATE ON SCHEMA mustream_schm FROM management;
-- REVOKE TRUNCATE ON ALL TABLES IN SCHEMA mustream_schm FROM management;
-- grant usage on schema mustream_schm to management;
--
-- /*creator permissions -
--   restrictions:
-- do not allow any form of contact with the following tables: ad logs, ads, creator payments, developer payments, developers users, management payments, management users, payment logs, payments, subscriptions, subscription plans
-- allow only select: artists
-- allow only select, insert update in songs, and only allow to delete a row that is only related to the user that inserted the data
-- allow only select: users*/
-- REVOKE ALL ON ALL TABLES IN SCHEMA public FROM creator;
-- REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM creator;
-- REVOKE ALL ON TABLE mustream_schm.ad_logs, mustream_schm.ads, mustream_schm.artist_payments, mustream_schm.developer_payments_view,
--     mustream_schm.management_payments_view, mustream_schm.payment_records, mustream_schm.payment_distribution, mustream_schm.subscription,
--     mustream_schm.subscription_plans, mustream_schm.artist_detailed_payments_view, mustream_schm.artist_discography,
--     mustream_schm.payment_summary_view, mustream_schm.genres
-- FROM creator;
-- GRANT SELECT ON mustream_schm.artists, mustream_schm.users TO creator;
-- GRANT SELECT, INSERT, UPDATE ON mustream_schm.songs TO creator;
-- ALTER TABLE mustream_schm.songs ENABLE ROW LEVEL SECURITY;
-- GRANT USAGE, SELECT ON SEQUENCE mustream_schm.songs_song_id_seq TO creator;
-- GRANT USAGE ON SCHEMA mustream_schm TO creator;
-- GRANT INSERT ON mustream_schm.songs TO creator;
--
-- DROP POLICY IF EXISTS creator_select_songs ON mustream_schm.songs;
-- DROP POLICY IF EXISTS creator_insert_songs ON mustream_schm.songs;
-- DROP POLICY IF EXISTS creator_update_songs ON mustream_schm.songs;
-- DROP POLICY IF EXISTS creator_delete_own_songs ON mustream_schm.songs;
--
-- -- CREATE OR REPLACE FUNCTION mustream_schm.set_current_user_id(p_user_id INTEGER) RETURNS VOID AS $$
-- -- BEGIN
-- --   PERFORM set_config('pg_temp.current_user_id', p_user_id::TEXT, FALSE);
-- -- END;
-- -- $$ LANGUAGE plpgsql SECURITY DEFINER;
--
-- CREATE OR REPLACE FUNCTION mustream_schm.set_current_user_id(p_user_id INTEGER) RETURNS VOID AS $$
-- BEGIN
--   PERFORM set_config('pg_temp.current_user_id', p_user_id::TEXT, FALSE);
-- END;
-- $$ LANGUAGE plpgsql SECURITY DEFINER;
--
-- CREATE POLICY creator_insert_songs
-- ON mustream_schm.songs
-- FOR INSERT TO creator
-- WITH CHECK (
--     artist_id IN (
--         SELECT artist_id FROM mustream_schm.artists
--         WHERE user_id = current_setting('pg_temp.current_user_id', true)::INTEGER
--     )
-- );
--
-- CREATE POLICY creator_update_songs
-- ON mustream_schm.songs
-- FOR UPDATE TO creator
-- USING (
--     EXISTS (
--         SELECT 1 FROM mustream_schm.artists
--         WHERE artists.artist_id = songs.artist_id
--         AND artists.user_id = current_setting('pg_temp.current_user_id', true)::INTEGER
--     )
-- );
--
-- CREATE POLICY creator_update_songs
-- ON mustream_schm.songs
-- FOR UPDATE TO creator
-- USING (
--     EXISTS (
--         SELECT 1 FROM mustream_schm.artists
--         WHERE artists.artist_id = songs.artist_id
--         AND artists.user_id = current_setting('pg_temp.current_user_id', true)::INTEGER
--     )
-- );
--
-- CREATE POLICY creator_select_songs
-- ON mustream_schm.songs
-- FOR SELECT TO creator
-- USING (true);
--
-- grant usage on schema mustream_schm to creator;
-- ALTER TABLE mustream_schm.songs ENABLE ROW LEVEL SECURITY;
--
-- /* listener permissions - allow select on: subscription, subscription plans, songs, artists
-- and on the rest restrict any form of access*/
-- REVOKE ALL ON ALL TABLES IN SCHEMA public FROM listener;
-- REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM listener;
-- GRANT SELECT ON mustream_schm.subscription, mustream_schm.subscription_plans, mustream_schm.songs, mustream_schm.artists TO listener;
--
-- ALTER TABLE mustream_schm.subscription ENABLE ROW LEVEL SECURITY;
-- -- create a policy to allow a listener to update only their own subscription
-- CREATE POLICY listener_update_own_subscription
-- ON mustream_schm.subscription
-- FOR UPDATE
-- USING (user_id = current_setting('app.current_user_id')::INT);
--
-- GRANT UPDATE (plan_name) ON mustream_schm.subscription TO listener;
-- grant usage on schema mustream_schm to listener;
-- GRANT USAGE, SELECT, UPDATE ON SEQUENCE mustream_schm.subscription_subscription_id_seq to listener;


/* Developer Permissions - Full Access */
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mustream_schm TO developer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO developer;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO developer;
GRANT USAGE ON SCHEMA mustream_schm TO developer;

/* Management Permissions - No Delete, Create, or Drop */
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA mustream_schm TO management;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO management;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO management;
REVOKE DELETE ON ALL TABLES IN SCHEMA mustream_schm FROM management;
REVOKE CREATE ON SCHEMA mustream_schm FROM management;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA mustream_schm FROM management;
GRANT USAGE ON SCHEMA mustream_schm TO management;

/* Creator Permissions - Limited to Songs, Artists, and Genres */
REVOKE ALL ON ALL TABLES IN SCHEMA mustream_schm FROM creator;
GRANT SELECT, INSERT, UPDATE ON mustream_schm.songs, mustream_schm.artists, mustream_schm.genres TO creator;
GRANT USAGE ON SCHEMA mustream_schm TO creator;

/* Listener Permissions - Read-Only on Songs, Artists, and Genres */
REVOKE ALL ON ALL TABLES IN SCHEMA mustream_schm FROM listener;
GRANT SELECT ON mustream_schm.songs, mustream_schm.artists, mustream_schm.genres TO listener;
GRANT USAGE ON SCHEMA mustream_schm TO listener;
