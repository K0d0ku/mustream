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

-- TODO - to create a payments system to show the revenue from ads and subscriptions, and split the payments to devs management and creators

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

    -- Revenue breakdown
    ad_revenue DECIMAL(15,2) NOT NULL,
    subscription_revenue DECIMAL(15,2) NOT NULL,
    total_revenue DECIMAL(15,2) NOT NULL,

    -- Developer payment: 40% of total revenue + 50% of remaining subscription revenue
    developer_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((total_revenue * 0.4) + (subscription_revenue * 0.5)) STORED,

    -- Management payment: 40% of total revenue + 50% of remaining ad revenue
    management_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((total_revenue * 0.4) + (ad_revenue * 0.5)) STORED,

    -- Artist payment: 20% of total revenue + $5 per 200 monthly listeners
    artist_base_payment DECIMAL(15,2) GENERATED ALWAYS AS
        (total_revenue * 0.2) STORED,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_revenue FOREIGN KEY (revenue_id)
        REFERENCES mustream_schm.revenue_tracking(revenue_id) ON DELETE CASCADE
);

-- Artist payment tracking (for the $5 per 200 monthly listeners part)
CREATE TABLE mustream_schm.artist_payments (
    payment_id SERIAL PRIMARY KEY,
    distribution_id INT NOT NULL,
    artist_id INT NOT NULL,
    month DATE NOT NULL,
    monthly_listeners INT NOT NULL,

    -- Base payment from the total pool (divided among artists)
    base_payment_share DECIMAL(15,2) NOT NULL,

    -- Additional payment based on listeners: $5 per 200 listeners
    listener_payment DECIMAL(15,2) GENERATED ALWAYS AS
        ((monthly_listeners::numeric / 200) * 5.00) STORED,

    -- Total payment to artist
    total_payment DECIMAL(15,2) GENERATED ALWAYS AS
        (base_payment_share + ((monthly_listeners::numeric / 200) * 5.00)) STORED,

    payment_date TIMESTAMP,
    payment_status TEXT DEFAULT 'pending',

    CONSTRAINT fk_artist_payment_distribution FOREIGN KEY (distribution_id)
        REFERENCES mustream_schm.payment_distribution(distribution_id) ON DELETE CASCADE,
    CONSTRAINT fk_artist_payment_artist FOREIGN KEY (artist_id)
        REFERENCES mustream_schm.artists(artist_id) ON DELETE CASCADE
);

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

-- Create a function to generate artist payments for a given month
CREATE OR REPLACE FUNCTION mustream_schm.generate_artist_payments(payment_month DATE)
RETURNS VOID AS $$
DECLARE
    v_distribution_id INT;
    v_artist_base_payment DECIMAL(15,2);
    r_artist RECORD;
    v_artist_count INT;
BEGIN
    -- Get the distribution ID for the given month
    SELECT distribution_id, artist_base_payment INTO v_distribution_id, v_artist_base_payment
    FROM mustream_schm.payment_distribution
    WHERE month = payment_month;

    IF v_distribution_id IS NULL THEN
        RAISE EXCEPTION 'No payment distribution found for month %', payment_month;
    END IF;

    -- Count the number of active artists
    SELECT COUNT(*) INTO v_artist_count FROM mustream_schm.artists;

    -- Calculate individual base payment share
    IF v_artist_count > 0 THEN
        v_artist_base_payment := v_artist_base_payment / v_artist_count;
    ELSE
        v_artist_base_payment := 0;
    END IF;

    -- Insert payment records for each artist
    FOR r_artist IN SELECT artist_id, monthly_listener_count FROM mustream_schm.artists LOOP
        INSERT INTO mustream_schm.artist_payments (
            distribution_id, artist_id, month, monthly_listeners, base_payment_share
        ) VALUES (
            v_distribution_id, r_artist.artist_id, payment_month, r_artist.monthly_listener_count, v_artist_base_payment
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- First, record revenue for a month
INSERT INTO mustream_schm.revenue_tracking (month, ad_revenue, subscription_revenue)
VALUES ('2025-02-01', 10000.00, 8000.00);

-- Then create the payment distribution record
INSERT INTO mustream_schm.payment_distribution
(revenue_id, month, ad_revenue, subscription_revenue, total_revenue)
SELECT revenue_id, month, ad_revenue, subscription_revenue, total_revenue
FROM mustream_schm.revenue_tracking
WHERE month = '2025-02-01';

-- Generate artist payments automatically
SELECT mustream_schm.generate_artist_payments('2025-02-01');

-- View all payment information
SELECT * FROM mustream_schm.payment_summary_view WHERE month = '2025-02-01';


/*new addition tables*/

CREATE TABLE mustream_schm.genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name TEXT UNIQUE NOT NULL
);

-- -- updated the songs table to reference the genre from the genre table
-- ALTER TABLE mustream_schm.songs
-- /*DROP COLUMN genre,*/
-- ADD COLUMN genre_id INT,
-- ADD CONSTRAINT fk_song_genre FOREIGN KEY (genre_id) REFERENCES mustream_schm.genres(genre_id) ON DELETE SET NULL;

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
/*Execute*/
/*SELECT * FROM mustream_schm.artist_discography WHERE artist_name = 'DJ Creator1';*/