CREATE TABLE mustream_schm.users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE mustream_schm.artists (
    artist_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE,
    artist_name TEXT NOT NULL,
    real_name TEXT,
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monthly_listener_count INT DEFAULT 0,
    CONSTRAINT fk_artist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE mustream_schm.songs (
    song_id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL,
    song_name TEXT NOT NULL,
--     genre TEXT NOT NULL, -- dropped since it is is own table now
    listeners_count INT DEFAULT 0,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    copyright_owner TEXT,
    CONSTRAINT fk_song_artist FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

CREATE TABLE ads (
    ad_id SERIAL PRIMARY KEY,
    ad_name TEXT NOT NULL,
    ad_cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    advertiser_company TEXT NOT NULL,
    advertiser_email TEXT NOT NULL
);

CREATE TABLE ad_logs (
    log_id SERIAL PRIMARY KEY,
    ad_id INT NOT NULL,
    views INT DEFAULT 0,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ad_log FOREIGN KEY (ad_id) REFERENCES ads(ad_id) ON DELETE CASCADE
);

CREATE TABLE mustream_schm.subscription_plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name TEXT UNIQUE NOT NULL,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    subscribed_amount INT DEFAULT 0,
    cancelled_amount INT DEFAULT 0,
    plan_description TEXT
);

CREATE TABLE mustream_schm.subscription (
    subscription_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    user_id INT NOT NULL,
    plan_name TEXT NOT NULL,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'active',
    CONSTRAINT fk_subscription_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_subscription_plan_name FOREIGN KEY (plan_name) REFERENCES subscription_plans(plan_name) ON DELETE CASCADE
);

-- Revenue tracking table
CREATE TABLE mustream_schm.revenue_tracking (
    revenue_id SERIAL PRIMARY KEY,
    month DATE NOT NULL,  -- Storing by month for reporting
    ad_revenue DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    subscription_revenue DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    total_revenue DECIMAL(15,2) GENERATED ALWAYS AS
        (ad_revenue + subscription_revenue) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment distribution table
CREATE TABLE mustream_schm.payment_distribution (
    distribution_id SERIAL PRIMARY KEY,
    revenue_id INT NOT NULL,
    month DATE NOT NULL,

    ad_revenue DECIMAL(15,2) NOT NULL,
    subscription_revenue DECIMAL(15,2) NOT NULL,
    total_revenue DECIMAL(15,2) NOT NULL,

    developer_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((total_revenue * 0.4) + (subscription_revenue * 0.5)) STORED,

    management_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((total_revenue * 0.4) + (ad_revenue * 0.5)) STORED,

    artist_base_payment DECIMAL(15,2) GENERATED ALWAYS AS
        (total_revenue * 0.2) STORED,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_revenue FOREIGN KEY (revenue_id)
        REFERENCES mustream_schm.revenue_tracking(revenue_id) ON DELETE CASCADE
);
-- delete from mustream_schm.payment_distribution
-- where distribution_id between 2 and 3;
ALTER TABLE mustream_schm.payment_distribution
ADD CONSTRAINT unique_month_in_distribution UNIQUE (month);


-- Artist payment tracking (for the $5 per 200 monthly listeners part)
CREATE TABLE mustream_schm.artist_payments (
    payment_id SERIAL PRIMARY KEY,
    distribution_id INT NOT NULL,
    artist_id INT NOT NULL,
    month DATE NOT NULL,
    monthly_listeners INT NOT NULL,

    base_payment_share DECIMAL(15,2) NOT NULL,

    listener_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((monthly_listeners::numeric / 200) * 5.00) STORED,

    total_payment DECIMAL(15,2) GENERATED ALWAYS AS
        (base_payment_share + ((monthly_listeners::numeric / 200) * 5.00)) STORED,

    payment_date TIMESTAMP,
    payment_status TEXT DEFAULT 'pending',

    CONSTRAINT fk_artist_payment_distribution FOREIGN KEY (distribution_id)
        REFERENCES mustream_schm.payment_distribution(distribution_id) ON DELETE CASCADE,
    CONSTRAINT fk_artist_payment_artist FOREIGN KEY (artist_id)
        REFERENCES mustream_schm.artists(artist_id) ON DELETE CASCADE
);

-- ALTER TABLE mustream_schm.artist_payments
-- ADD CONSTRAINT unique_artist_month UNIQUE (artist_id, month);

-- View to see all payment information at once
CREATE OR REPLACE VIEW mustream_schm.payment_summary_view AS
SELECT
    rt.month,
    rt.ad_revenue,
    rt.subscription_revenue,
    rt.total_revenue,
    pd.developer_payment,
    pd.management_payment,
    pd.artist_base_payment,
    (SELECT SUM(ap.listener_payment) FROM mustream_schm.artist_payments ap WHERE ap.month = rt.month) AS artist_listener_payment,
    (pd.artist_base_payment + COALESCE((SELECT SUM(ap.listener_payment) FROM mustream_schm.artist_payments ap WHERE ap.month = rt.month), 0)) AS artist_total_payment,
    pd.developer_payment + pd.management_payment +
        (pd.artist_base_payment + COALESCE((SELECT SUM(ap.listener_payment) FROM mustream_schm.artist_payments ap WHERE ap.month = rt.month), 0)) AS total_payments_distributed
FROM
    mustream_schm.revenue_tracking rt
JOIN
    mustream_schm.payment_distribution pd ON rt.revenue_id = pd.revenue_id;

-- procedure to automate stuff:
-- this procedure creates a function to generate artist payments for a given month
CREATE OR REPLACE PROCEDURE mustream_schm.generate_all_payments_proc(payment_month DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    --1: insert into payment_distribution from revenue_tracking
    INSERT INTO mustream_schm.payment_distribution (
        revenue_id, month, ad_revenue, subscription_revenue, total_revenue
    )
    SELECT revenue_id, month, ad_revenue, subscription_revenue, total_revenue
    FROM mustream_schm.revenue_tracking
    WHERE month = payment_month
    ON CONFLICT (month) DO NOTHING; -- Prevent duplicate entries

    -- 2: generate artist payments (calculates the payment based on distribution)
    PERFORM mustream_schm.generate_artist_payments(payment_month);

    /*3: insert into payment_records by the roles,
      for developers*/
    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT user_id, 'developer', month, individual_payment
    FROM mustream_schm.developer_payments_view
    WHERE month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

    -- management
    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT user_id, 'management', month, individual_payment
    FROM mustream_schm.management_payments_view
    WHERE month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

    -- artists
    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT user_id, 'artist', month, total_payment
    FROM mustream_schm.artist_detailed_payments_view
    WHERE month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

    -- log the payment generation
    INSERT INTO mustream_schm.payment_audit_log (event_type, event_data)
    VALUES ('payment_generation', jsonb_build_object('month', payment_month));

END;
$$;
-- rollback ;


/*execute*/
BEGIN;
INSERT INTO mustream_schm.revenue_tracking (month, ad_revenue, subscription_revenue)
VALUES ('2025-04-17', 10000.00, 8000.00);

CALL mustream_schm.generate_all_payments_proc('2025-04-17');
SAVEPOINT payments_v_1;
COMMIT;/*transaction*/

CREATE OR REPLACE FUNCTION mustream_schm.generate_artist_payments(payment_month DATE)
RETURNS VOID AS $$
DECLARE
    v_distribution_id INT;
    v_artist_base_payment DECIMAL(15,2);
    r_artist RECORD;
    v_artist_count INT;
    v_total_revenue DECIMAL(15,2);
BEGIN
    -- get the distribution info on the month
    SELECT distribution_id, artist_base_payment INTO v_distribution_id, v_artist_base_payment
    FROM mustream_schm.payment_distribution
    WHERE month = payment_month;

    IF v_distribution_id IS NULL THEN
        RAISE EXCEPTION 'No payment distribution found for month %', payment_month;
    END IF;

    -- count the number of artists
    SELECT COUNT(*) INTO v_artist_count FROM mustream_schm.artists;

    IF v_artist_count > 0 THEN
        v_artist_base_payment := v_artist_base_payment / v_artist_count;
    ELSE
        v_artist_base_payment := 0;
    END IF;

    -- loop through all artists and calculate payments
    FOR r_artist IN
    SELECT artist_id, monthly_listener_count
    FROM mustream_schm.artists
    WHERE monthly_listener_count IS NOT NULL
    LOOP
        INSERT INTO mustream_schm.artist_payments (
            distribution_id, artist_id, month, monthly_listeners, base_payment_share
        ) VALUES (
            v_distribution_id, r_artist.artist_id, payment_month,
            r_artist.monthly_listener_count, v_artist_base_payment
        )
        ON CONFLICT (artist_id, month)
        DO UPDATE SET
            base_payment_share = EXCLUDED.base_payment_share,
            monthly_listeners = EXCLUDED.monthly_listeners;
    END LOOP;

END;
$$ LANGUAGE plpgsql;

CREATE TABLE mustream_schm.payment_audit_log (
    log_id SERIAL PRIMARY KEY,
    event_type TEXT,
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_data JSONB
);

CREATE TRIGGER revenue_tracking_insert_trigger
AFTER INSERT ON mustream_schm.revenue_tracking
FOR EACH ROW
EXECUTE FUNCTION mustream_schm.revenue_insert_trigger_func();

CREATE OR REPLACE FUNCTION mustream_schm.revenue_insert_trigger_func()
RETURNS TRIGGER AS $$
DECLARE
    v_month DATE;
BEGIN
    v_month := NEW.month;

    --  1: insert payment distribution from revenue_tracking
    INSERT INTO mustream_schm.payment_distribution (revenue_id, month, ad_revenue, subscription_revenue, total_revenue)
    SELECT revenue_id, month, ad_revenue, subscription_revenue, total_revenue
    FROM mustream_schm.revenue_tracking
    WHERE month = NEW.month
    ON CONFLICT (month) DO NOTHING;


    -- 2: generate artist payments (calculate based on distribution)
    PERFORM mustream_schm.generate_artist_payments(v_month);

    -- 3: call procedure to generate all payments (devs, mgmt, artists)
    CALL mustream_schm.generate_all_payments_proc(NEW.month);

    -- log for auditing purposes
    INSERT INTO mustream_schm.payment_audit_log (event_type, event_data)
    VALUES ('payment_generation', jsonb_build_object('month', v_month));

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


/*new addition tables*/
CREATE TABLE mustream_schm.genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name TEXT UNIQUE NOT NULL
);

CREATE VIEW mustream_schm.artist_discography AS
SELECT
    a.artist_id,
    a.artist_name,
    a.real_name,
    a.joined_date,
    u.user_id,
    u.username,
    u.email,
    s.song_id,
    s.song_name,
    g.genre_name,
    s.listeners_count,
    s.date_created,
    s.copyright_owner
FROM mustream_schm.artists a
JOIN mustream_schm.users u ON a.user_id = u.user_id
LEFT JOIN mustream_schm.songs s ON a.artist_id = s.artist_id
LEFT JOIN mustream_schm.genres g ON s.genre_id = g.genre_id;
/*Execute*/ /*this has been automated*/
-- SELECT * FROM mustream_schm.artist_discography WHERE artist_name = 'DJ Creator1';


/*procedure to automate the artist discography*/
CREATE TABLE mustream_schm.artist_view_log (
    id SERIAL PRIMARY KEY,
    artist_name TEXT NOT NULL,
    view_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- create a view to store all info but upon calling a procedure the info will change to the one that is desired
CREATE OR REPLACE VIEW mustream_schm.artist_discography_view AS
SELECT
    a.artist_id,
    a.artist_name,
    a.real_name,
    a.joined_date,
    u.user_id,
    u.username,
    u.email,
    s.song_id,
    s.song_name,
    g.genre_name,
    s.listeners_count,
    s.date_created,
    s.copyright_owner
FROM mustream_schm.artists a
JOIN mustream_schm.users u ON a.user_id = u.user_id
LEFT JOIN mustream_schm.songs s ON a.artist_id = s.artist_id
LEFT JOIN mustream_schm.genres g ON s.genre_id = g.genre_id;


-- then create a procedure that sets a session variable and displays results
CREATE OR REPLACE PROCEDURE mustream_schm.get_artist_discography_proc(
    IN artist_name_param TEXT,
    OUT record_count INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO mustream_schm.artist_view_log (artist_name)
    VALUES (artist_name_param);

    CREATE TEMP TABLE IF NOT EXISTS temp_discography AS
    SELECT * FROM mustream_schm.artist_discography_view WHERE FALSE;
    TRUNCATE TABLE temp_discography;
    INSERT INTO temp_discography
    SELECT * FROM mustream_schm.artist_discography_view
    WHERE artist_name = artist_name_param;

    SELECT COUNT(*) INTO record_count FROM temp_discography;

    IF record_count = 0 THEN
        RAISE NOTICE 'No discography found for artist: %', artist_name_param;
    ELSE
        RAISE NOTICE 'Found % records for artist: %', record_count, artist_name_param;
        RAISE NOTICE 'Run: SELECT * FROM temp_discography;';
    END IF;
END;
$$;
-- rollback ;
/*execute*/
BEGIN;
CALL mustream_schm.get_artist_discography_proc('BeatsByC2', record_count := NULL);
-- CALL mustream_schm.get_artist_discography_proc('SynthLord6', record_count := NULL);
-- CALL mustream_schm.get_artist_discography_proc('THE WaveMaker', record_count := NULL);
COMMIT; /*transaction*/
/*this will give an error but dont worry it is working as intended cause
  its temporary thats why ide is not able to find its origin*/
SELECT * FROM temp_discography;

/*trigger upon checking an artist this trigger adds +10 views to the ads in ad_logs*/
/*row level trigger*/
CREATE TRIGGER bump_ad_views_on_artist_check
AFTER INSERT ON mustream_schm.artist_view_log
FOR EACH ROW
EXECUTE FUNCTION mustream_schm.bump_random_ad_view_trigger();

CREATE OR REPLACE FUNCTION mustream_schm.bump_random_ad_view_trigger()
RETURNS TRIGGER AS $$
DECLARE
    random_ad_id INT;
BEGIN
    SELECT ad_id INTO random_ad_id
    FROM mustream_schm.ads
    ORDER BY RANDOM()
    LIMIT 1;

    IF random_ad_id IS NOT NULL THEN
        UPDATE mustream_schm.ad_logs
        SET views = views + 10,
            log_date = CURRENT_TIMESTAMP
        WHERE ad_id = random_ad_id;

        IF NOT FOUND THEN
            INSERT INTO mustream_schm.ad_logs (ad_id, views, log_date)
            VALUES (random_ad_id, 10, CURRENT_TIMESTAMP);
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;