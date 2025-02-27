INSERT INTO mustream_schm.subscription (username, user_id, plan_name, start_date, end_date, status)
VALUES
    -- Free Plan Subscribers
    ('listener1', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener1'), 'Free', DEFAULT, NULL, 'active'),
    ('listener2', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener2'), 'Free', DEFAULT, NULL, 'active'),
    ('listener3', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener3'), 'Free', DEFAULT, NULL, 'active'),
    ('listener4', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener4'), 'Free', DEFAULT, NULL, 'cancelled'),
    ('listener5', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener5'), 'Free', DEFAULT, NULL, 'active'),
    ('listener6', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener6'), 'Free', DEFAULT, NULL, 'active'),
    ('listener7', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener7'), 'Free', DEFAULT, NULL, 'cancelled'),
    ('listener8', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener8'), 'Free', DEFAULT, NULL, 'active'),
    ('listener9', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener9'), 'Free', DEFAULT, NULL, 'active'),
    ('listener10', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener10'), 'Free', DEFAULT, NULL, 'cancelled'),

    -- Premium Plan Subscribers
    ('listener12', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener12'), 'Premium', DEFAULT, CURRENT_TIMESTAMP + INTERVAL '1 month', 'active'),
    ('listener11', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener11'), 'Premium', DEFAULT, CURRENT_TIMESTAMP + INTERVAL '1 month', 'active'),
    ('listener13', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener13'), 'Premium', DEFAULT, CURRENT_TIMESTAMP + INTERVAL '1 month', 'cancelled'),
    ('listener14', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener14'), 'Premium', DEFAULT, CURRENT_TIMESTAMP + INTERVAL '1 month', 'active'),
    ('listener15', (SELECT user_id FROM mustream_schm.users WHERE username = 'listener15'), 'Premium', DEFAULT, CURRENT_TIMESTAMP + INTERVAL '1 month', 'active');