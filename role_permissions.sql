/*developer permissions - all access*/
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mustream_schm TO developer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO developer;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO developer;

/*management permissions -
  allow: read, update, insert
  revoke: delete, create, drop*/
-- grant SELECT, INSERT, and UPDATE, but prevent DELETE and CREATE/DROP
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA mustream_schm TO management;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mustream_schm TO management;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mustream_schm TO management;
-- revoke DELETE and CREATE/DROP permissions
REVOKE DELETE ON ALL TABLES IN SCHEMA mustream_schm FROM management;
REVOKE CREATE ON SCHEMA mustream_schm FROM management;
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA mustream_schm FROM management;

/*creator permissions -
  restrictions:
do not allow any form of contact with the following tables: ad logs, ads, creator payments, developer payments, developers users, management payments, management users, payment logs, payments, subscriptions, subscription plans
allow only select: artists
allow only select, insert update in songs, and only allow to delete a row that is only related to the user that inserted the data
allow only select: users*/
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM creator;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM creator;
REVOKE ALL ON TABLE mustream_schm.ad_logs, mustream_schm.ads, mustream_schm.creator_payments, mustream_schm.developer_payments,
    mustream_schm.developer_users, mustream_schm.management_payments, mustream_schm.management_users,
    mustream_schm.payment_logs, mustream_schm.payments, mustream_schm.subscription, mustream_schm.subscription_plans
FROM creator;
GRANT SELECT ON mustream_schm.artists, mustream_schm.users TO creator;
GRANT SELECT, INSERT, UPDATE ON mustream_schm.songs TO creator;
ALTER TABLE mustream_schm.songs ENABLE ROW LEVEL SECURITY;

CREATE POLICY creator_delete_own_songs
ON mustream_schm.songs
FOR DELETE
USING (
    artist_id IN (
        SELECT artist_id FROM mustream_schm.artists
        WHERE user_id = current_user::INT
    )
);

/* listener permissions - allow select on: subscription, subscription plans, songs, artists
and on the rest restrict any form of access*/
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM listener;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM listener;
GRANT SELECT ON mustream_schm.subscription, mustream_schm.subscription_plans, mustream_schm.songs, mustream_schm.artists TO listener;
