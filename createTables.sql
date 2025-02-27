-- CREATE TABLE mustream_schm.users (
--     user_id SERIAL PRIMARY KEY,
--     username TEXT NOT NULL,
--     email TEXT UNIQUE NOT NULL,
--     password_hash TEXT NOT NULL,
--     role TEXT NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- CREATE TABLE mustream_schm.artists (
--     artist_id SERIAL PRIMARY KEY,
--     user_id INT UNIQUE,
--     artist_name TEXT NOT NULL,
--     real_name TEXT,
--     joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     monthly_listener_count INT DEFAULT 0,
--     CONSTRAINT fk_artist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
-- );
--
-- CREATE TABLE mustream_schm.songs (
--     song_id SERIAL PRIMARY KEY,
--     artist_id INT NOT NULL,
--     song_name TEXT NOT NULL,
--     genre TEXT NOT NULL,
--     listeners_count INT DEFAULT 0,
--     date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     copyright_owner TEXT,
--     CONSTRAINT fk_song_artist FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
-- );
--
-- CREATE TABLE ads (
--     ad_id SERIAL PRIMARY KEY,
--     ad_name TEXT NOT NULL,
--     ad_cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
--     advertiser_company TEXT NOT NULL,
--     advertiser_email TEXT NOT NULL
-- );
--
-- CREATE TABLE ad_logs (
--     log_id SERIAL PRIMARY KEY,
--     ad_id INT NOT NULL,
--     views INT DEFAULT 0,
--     log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     CONSTRAINT fk_ad_log FOREIGN KEY (ad_id) REFERENCES ads(ad_id) ON DELETE CASCADE
-- );
--
-- CREATE TABLE mustream_schm.subscription_plans (
--     plan_id SERIAL PRIMARY KEY,
--     plan_name TEXT UNIQUE NOT NULL,
--     price NUMERIC(10,2) NOT NULL DEFAULT 0.00,
--     subscribed_amount INT DEFAULT 0,
--     cancelled_amount INT DEFAULT 0,
--     plan_description TEXT
-- );
--
-- CREATE TABLE mustream_schm.subscription (
--     subscription_id SERIAL PRIMARY KEY,
--     username TEXT NOT NULL,
--     user_id INT NOT NULL,
--     plan_name TEXT NOT NULL,
--     start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     end_date TIMESTAMP,
--     status TEXT NOT NULL DEFAULT 'active',
--     CONSTRAINT fk_subscription_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
--     CONSTRAINT fk_subscription_plan_name FOREIGN KEY (plan_name) REFERENCES subscription_plans(plan_name) ON DELETE CASCADE
-- );

-- TODO - to create a payments system to show the revenue from ads and subscriptions, and split the payments to devs management and creators

/*PAYMENTS*/
/*EXECUTE TO REFRESH , Run only if data is missing or views are outdated.*/
-- create a view for ad revenue calculations
CREATE OR REPLACE VIEW mustream_schm.ad_revenue_view AS
SELECT
    DATE_TRUNC('month', al.log_date) AS payment_month,
    COALESCE(SUM(al.views * a.ad_cost), 0) as ad_revenue
FROM ad_logs al
JOIN ads a ON al.ad_id = a.ad_id
GROUP BY DATE_TRUNC('month', al.log_date);

-- create a view for subscription revenue
CREATE OR REPLACE VIEW mustream_schm.subscription_revenue_view AS
SELECT
    COALESCE(SUM(price * subscribed_amount), 0) as subscription_revenue
FROM mustream_schm.subscription_plans;

-- create a view for artist metrics
CREATE OR REPLACE VIEW mustream_schm.artist_metrics_view AS
SELECT
    COALESCE(SUM(monthly_listener_count), 0) as total_monthly_listeners,
    COALESCE((SUM(monthly_listener_count) / 200.0) * 5, 0) as base_creator_payment
FROM mustream_schm.artists;
--
-- create the main payments table
CREATE TABLE mustream_schm.payments (
    payment_date DATE PRIMARY KEY,
    ad_revenue DECIMAL(10,2),
    subscription_revenue DECIMAL(10,2),
    total_revenue DECIMAL(10,2) GENERATED ALWAYS AS (ad_revenue + subscription_revenue) STORED,
    dev_payment DECIMAL(10,2) GENERATED ALWAYS AS (
        (subscription_revenue * 0.50) + ((ad_revenue + subscription_revenue) * 0.40)
    ) STORED,
    management_payment DECIMAL(10,2) GENERATED ALWAYS AS (
        (ad_revenue * 0.50) + ((ad_revenue + subscription_revenue) * 0.40)
    ) STORED,
    creator_payment DECIMAL(10,2)
);

/*EXECUTE 1*/
CREATE OR REPLACE FUNCTION mustream_schm.update_monthly_payments(payment_month DATE)
RETURNS void AS $$
BEGIN
    -- insert or update the payment record
    INSERT INTO mustream_schm.payments (
        payment_date,
        ad_revenue,
        subscription_revenue,
        creator_payment
    )
    SELECT
        update_monthly_payments.payment_month,
        arv.ad_revenue,
        srv.subscription_revenue,
        amv.base_creator_payment +
        (((COALESCE(arv.ad_revenue, 0) + srv.subscription_revenue) * 0.20) /
         NULLIF(amv.total_monthly_listeners, 0))
    FROM mustream_schm.ad_revenue_view arv
    CROSS JOIN mustream_schm.subscription_revenue_view srv
    CROSS JOIN mustream_schm.artist_metrics_view amv
    WHERE arv.payment_month = update_monthly_payments.payment_month
    ON CONFLICT (payment_date) DO UPDATE SET
        ad_revenue = EXCLUDED.ad_revenue,
        subscription_revenue = EXCLUDED.subscription_revenue,
        creator_payment = EXCLUDED.creator_payment;
END
$$ LANGUAGE plpgsql;

/*EXECUTE 2*/
-- 1. PROCEDURE: Monthly payment processing
CREATE OR REPLACE PROCEDURE mustream_schm.process_monthly_payments()
LANGUAGE plpgsql
AS $$
DECLARE
    current_month DATE;
BEGIN
    -- get the first day of the current month
    current_month := DATE_TRUNC('month', CURRENT_DATE);

    -- process previous month's payments (we're paying for the previous month)
    SELECT mustream_schm.update_monthly_payments(current_month - INTERVAL '1 month');

    -- log the payment processing
    INSERT INTO mustream_schm.payment_logs (
        log_date,
        log_message
    ) VALUES (
        CURRENT_TIMESTAMP,
        'Monthly payments processed for ' || TO_CHAR(current_month - INTERVAL '1 month', 'YYYY-MM')
    );

    COMMIT;
END;
$$;

-- 2. EVENT TRIGGER: Schedule the payment processing on the 1st of each month
-- EXECUTE the trigger monthly payment
-- 3. PAYMENT LOGS TABLE: Track payment processing history
-- CREATE TABLE IF NOT EXISTS mustream_schm.payment_logs (
--     log_id SERIAL PRIMARY KEY,
--     log_date TIMESTAMP NOT NULL,
--     log_message TEXT NOT NULL
-- );

-- 4. MANUAL PAYMENT PROCESSING FUNCTION: For ad-hoc or missed payments
CREATE OR REPLACE FUNCTION mustream_schm.process_payment_for_month(target_month DATE)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    normalized_date DATE;
    result_message TEXT;
BEGIN
    -- Normalize the date to first of month
    normalized_date := DATE_TRUNC('month', target_month);

    -- Call the update function
    PERFORM mustream_schm.update_monthly_payments(normalized_date);

    -- Log the manual payment processing
    INSERT INTO mustream_schm.payment_logs (
        log_date,
        log_message
    ) VALUES (
        CURRENT_TIMESTAMP,
        'Manual payment processing for ' || TO_CHAR(normalized_date, 'YYYY-MM')
    );

    result_message := 'Successfully processed payments for ' || TO_CHAR(normalized_date, 'YYYY-MM');
    RETURN result_message;
END;
$$;

-- 5. PAYMENT NOTIFICATION VIEW: For sending notifications
CREATE OR REPLACE VIEW mustream_schm.payment_notifications AS
SELECT
    p.payment_date,
    p.total_revenue,
    'Developer' AS recipient_type,
    p.dev_payment AS amount
FROM mustream_schm.payments p
UNION ALL
SELECT
    p.payment_date,
    p.total_revenue,
    'Management' AS recipient_type,
    p.management_payment AS amount
FROM mustream_schm.payments p
UNION ALL
SELECT
    p.payment_date,
    p.total_revenue,
    'Content Creators' AS recipient_type,
    p.creator_payment AS amount
FROM mustream_schm.payments p;

/*Payments split*/ /*EXECUTE*/
-- -- Developer users table
CREATE TABLE IF NOT EXISTS mustream_schm.developer_users (
    dev_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,            -- Reference to main users table
    dev_name VARCHAR(100) NOT NULL,
    contribution_weight DECIMAL(5,2) NOT NULL DEFAULT 1.0,  -- Relative contribution for payment distribution
    active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT dev_contribution_positive CHECK (contribution_weight > 0)
);
-- Management users table
CREATE TABLE IF NOT EXISTS mustream_schm.management_users (
    mgmt_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,            -- Reference to main users table
    mgmt_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    contribution_weight DECIMAL(5,2) NOT NULL DEFAULT 1.0,  -- Relative contribution for payment distribution
    active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT mgmt_contribution_positive CHECK (contribution_weight > 0)
);
-- Creator users table (extends existing artists table)
CREATE TABLE IF NOT EXISTS mustream_schm.creator_users (
    creator_id SERIAL PRIMARY KEY,
    artist_id INT NOT NULL,          -- Reference to artists table
    user_id INT NOT NULL,            -- Reference to main users table
    creator_name VARCHAR(100) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Developer payments table
CREATE TABLE IF NOT EXISTS mustream_schm.developer_payments (
    payment_id SERIAL PRIMARY KEY,
    payment_date DATE NOT NULL,      -- Reference to payments table
    dev_id INT NOT NULL,             -- Reference to developer_users
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    payment_details JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_dev_payment_date FOREIGN KEY (payment_date) REFERENCES mustream_schm.payments(payment_date),
    CONSTRAINT fk_dev_user FOREIGN KEY (dev_id) REFERENCES mustream_schm.developer_users(dev_id)
);
-- Management payments table
CREATE TABLE IF NOT EXISTS mustream_schm.management_payments (
    payment_id SERIAL PRIMARY KEY,
    payment_date DATE NOT NULL,      -- Reference to payments table
    mgmt_id INT NOT NULL,            -- Reference to management_users
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    payment_details JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_mgmt_payment_date FOREIGN KEY (payment_date) REFERENCES mustream_schm.payments(payment_date),
    CONSTRAINT fk_mgmt_user FOREIGN KEY (mgmt_id) REFERENCES mustream_schm.management_users(mgmt_id)
);
-- Creator payments table
CREATE TABLE IF NOT EXISTS mustream_schm.creator_payments (
    payment_id SERIAL PRIMARY KEY,
    payment_date DATE NOT NULL,      -- Reference to payments table
    creator_id INT NOT NULL,         -- Reference to creator_users
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    payment_details JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_creator_payment_date FOREIGN KEY (payment_date) REFERENCES mustream_schm.payments(payment_date),
    CONSTRAINT fk_creator_user FOREIGN KEY (creator_id) REFERENCES mustream_schm.creator_users(creator_id)
);

/*EXECUTE*/
-- Function to distribute developer payments
CREATE OR REPLACE FUNCTION mustream_schm.distribute_developer_payments(p_payment_date DATE)
RETURNS void AS $$
DECLARE
    v_total_payment DECIMAL(10,2);
    v_total_weight DECIMAL(10,2);
BEGIN
    -- Get the total payment amount for developers from the payments table
    SELECT dev_payment INTO v_total_payment
    FROM mustream_schm.payments
    WHERE payment_date = p_payment_date;

    -- If no payment found, exit
    IF v_total_payment IS NULL THEN
        RAISE EXCEPTION 'No payment record found for date %', p_payment_date;
    END IF;

    -- Get the sum of all contribution weights
    SELECT COALESCE(SUM(contribution_weight), 0) INTO v_total_weight
    FROM mustream_schm.developer_users
    WHERE active = TRUE;

    -- If no active developers, exit
    IF v_total_weight = 0 THEN
        RAISE EXCEPTION 'No active developers found for payment distribution';
    END IF;

    -- Delete any existing payments for this date (for idempotence)
    DELETE FROM mustream_schm.developer_payments
    WHERE payment_date = p_payment_date;

    -- Insert payment records for each developer
    INSERT INTO mustream_schm.developer_payments (
        payment_date,
        dev_id,
        payment_amount,
        payment_details,
        updated_at
    )
    SELECT
        p_payment_date,
        dev_id,
        ROUND((contribution_weight / v_total_weight) * v_total_payment, 2),
        jsonb_build_object(
            'total_payment', v_total_payment,
            'total_weight', v_total_weight,
            'individual_weight', contribution_weight,
            'payment_percentage', ROUND((contribution_weight / v_total_weight) * 100, 2)
        ),
        CURRENT_TIMESTAMP
    FROM mustream_schm.developer_users
    WHERE active = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function to distribute management payments
CREATE OR REPLACE FUNCTION mustream_schm.distribute_management_payments(p_payment_date DATE)
RETURNS void AS $$
DECLARE
    v_total_payment DECIMAL(10,2);
    v_total_weight DECIMAL(10,2);
BEGIN
    -- Get the total payment amount for management from the payments table
    SELECT management_payment INTO v_total_payment
    FROM mustream_schm.payments
    WHERE payment_date = p_payment_date;

    -- If no payment found, exit
    IF v_total_payment IS NULL THEN
        RAISE EXCEPTION 'No payment record found for date %', p_payment_date;
    END IF;

    -- Get the sum of all contribution weights
    SELECT COALESCE(SUM(contribution_weight), 0) INTO v_total_weight
    FROM mustream_schm.management_users
    WHERE active = TRUE;

    -- If no active management, exit
    IF v_total_weight = 0 THEN
        RAISE EXCEPTION 'No active management users found for payment distribution';
    END IF;

    -- Delete any existing payments for this date (for idempotence)
    DELETE FROM mustream_schm.management_payments
    WHERE payment_date = p_payment_date;

    -- Insert payment records for each management user
    INSERT INTO mustream_schm.management_payments (
        payment_date,
        mgmt_id,
        payment_amount,
        payment_details,
        updated_at
    )
    SELECT
        p_payment_date,
        mgmt_id,
        ROUND((contribution_weight / v_total_weight) * v_total_payment, 2),
        jsonb_build_object(
            'total_payment', v_total_payment,
            'total_weight', v_total_weight,
            'individual_weight', contribution_weight,
            'payment_percentage', ROUND((contribution_weight / v_total_weight) * 100, 2),
            'department', department
        ),
        CURRENT_TIMESTAMP
    FROM mustream_schm.management_users
    WHERE active = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function to distribute creator payments based on monthly listeners
CREATE OR REPLACE FUNCTION mustream_schm.distribute_creator_payments(p_payment_date DATE)
RETURNS void AS $$
DECLARE
    v_total_payment DECIMAL(10,2);
    v_total_listeners INT;
BEGIN
    -- Get the total payment amount for creators from the payments table
    SELECT creator_payment INTO v_total_payment
    FROM mustream_schm.payments
    WHERE payment_date = p_payment_date;

    -- If no payment found, exit
    IF v_total_payment IS NULL THEN
        RAISE EXCEPTION 'No payment record found for date %', p_payment_date;
    END IF;

    -- Get the total number of monthly listeners across all active creators
    SELECT COALESCE(SUM(a.monthly_listener_count), 0) INTO v_total_listeners
    FROM mustream_schm.artists a
    JOIN mustream_schm.creator_users cu ON a.artist_id = cu.artist_id
    WHERE cu.active = TRUE;

    -- If no active creators or listeners, exit
    IF v_total_listeners = 0 THEN
        RAISE EXCEPTION 'No active creators or listeners found for payment distribution';
    END IF;

    -- Delete any existing payments for this date (for idempotence)
    DELETE FROM mustream_schm.creator_payments
    WHERE payment_date = p_payment_date;

    -- Insert payment records for each creator based on listener count
    INSERT INTO mustream_schm.creator_payments (
        payment_date,
        creator_id,
        payment_amount,
        payment_details,
        updated_at
    )
    SELECT
        p_payment_date,
        cu.creator_id,
        CASE
            WHEN v_total_listeners = 0 THEN 0
            ELSE ROUND((a.monthly_listener_count / v_total_listeners::numeric) * v_total_payment, 2)
        END,
        jsonb_build_object(
            'total_payment', v_total_payment,
            'total_listeners', v_total_listeners,
            'individual_listeners', a.monthly_listener_count,
            'payment_percentage', CASE
                WHEN v_total_listeners = 0 THEN 0
                ELSE ROUND((a.monthly_listener_count / v_total_listeners::numeric) * 100, 2)
            END
        ),
        CURRENT_TIMESTAMP
    FROM mustream_schm.creator_users cu
    JOIN mustream_schm.artists a ON cu.artist_id = a.artist_id
    WHERE cu.active = TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE mustream_schm.distribute_all_payments(p_payment_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Distribute developer payments
    PERFORM mustream_schm.distribute_developer_payments(p_payment_date);

    -- Distribute management payments
    PERFORM mustream_schm.distribute_management_payments(p_payment_date);

    -- Distribute creator payments
    PERFORM mustream_schm.distribute_creator_payments(p_payment_date);

    -- Log the distribution
    INSERT INTO mustream_schm.payment_logs (
        log_date,
        log_message
    ) VALUES (
        CURRENT_TIMESTAMP,
        'Payment distribution completed for ' || TO_CHAR(p_payment_date, 'YYYY-MM')
    );
END;
$$;

CREATE OR REPLACE VIEW mustream_schm.detailed_payments_view AS
-- Developer payments
SELECT
    'Developer' AS payment_type,
    p.payment_date,
    du.dev_name AS recipient_name,
    dp.payment_amount,
    dp.payment_status,
    dp.payment_details,
    dp.created_at
FROM mustream_schm.developer_payments dp
JOIN mustream_schm.developer_users du ON dp.dev_id = du.dev_id
JOIN mustream_schm.payments p ON dp.payment_date = p.payment_date

UNION ALL

-- Management payments
SELECT
    'Management' AS payment_type,
    p.payment_date,
    mu.mgmt_name AS recipient_name,
    mp.payment_amount,
    mp.payment_status,
    mp.payment_details,
    mp.created_at
FROM mustream_schm.management_payments mp
JOIN mustream_schm.management_users mu ON mp.mgmt_id = mu.mgmt_id
JOIN mustream_schm.payments p ON mp.payment_date = p.payment_date

UNION ALL

-- Creator payments
SELECT
    'Creator' AS payment_type,
    p.payment_date,
    cu.creator_name AS recipient_name,
    cp.payment_amount,
    cp.payment_status,
    cp.payment_details,
    cp.created_at
FROM mustream_schm.creator_payments cp
JOIN mustream_schm.creator_users cu ON cp.creator_id = cu.creator_id
JOIN mustream_schm.payments p ON cp.payment_date = p.payment_date;