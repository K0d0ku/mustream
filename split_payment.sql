CREATE OR REPLACE VIEW mustream_schm.developer_payments_view AS
WITH dev_count AS (
    SELECT COUNT(*) as total_devs
    FROM mustream_schm.users
    WHERE role = 'developer'
), latest_distributions AS (
    SELECT DISTINCT ON (month) *
    FROM mustream_schm.payment_distribution
    ORDER BY month, distribution_id DESC
)
SELECT
    u.user_id,
    u.username,
    pd.month,
    pd.developer_payment,
    CASE
        WHEN (SELECT total_devs FROM dev_count) > 0
        THEN pd.developer_payment / (SELECT total_devs FROM dev_count)
        ELSE 0
    END AS individual_payment,
    pd.total_revenue
FROM
    mustream_schm.users u
CROSS JOIN
    latest_distributions pd
WHERE
    u.role = 'developer'
ORDER BY
    pd.month DESC, u.username;

CREATE OR REPLACE VIEW mustream_schm.management_payments_view AS
WITH mgmt_count AS (
    SELECT COUNT(*) as total_mgmt
    FROM mustream_schm.users
    WHERE role = 'management'
), latest_distributions AS (
    SELECT DISTINCT ON (month) *
    FROM mustream_schm.payment_distribution
    ORDER BY month, distribution_id DESC
)
SELECT
    u.user_id,
    u.username,
    pd.month,
    pd.management_payment,
    CASE
        WHEN (SELECT total_mgmt FROM mgmt_count) > 0
        THEN pd.management_payment / (SELECT total_mgmt FROM mgmt_count)
        ELSE 0
    END AS individual_payment,
    pd.total_revenue
FROM
    mustream_schm.users u
CROSS JOIN
    latest_distributions pd
WHERE
    u.role = 'management'
ORDER BY
    pd.month DESC, u.username;

CREATE OR REPLACE VIEW mustream_schm.artist_detailed_payments_view AS
WITH latest_distributions AS (
    SELECT DISTINCT ON (month) *
    FROM mustream_schm.payment_distribution
    ORDER BY month, distribution_id DESC
),
artist_listeners AS (
    SELECT
        a.artist_id,
        a.user_id,
        a.artist_name,
        a.monthly_listener_count,
        SUM(a.monthly_listener_count) OVER (PARTITION BY pd.month) AS total_listeners,
        pd.month,
        pd.artist_base_payment,
        pd.total_revenue
    FROM
        mustream_schm.artists a
    CROSS JOIN
        latest_distributions pd
)
SELECT
    al.artist_id,
    u.user_id,
    u.username,
    al.artist_name,
    al.monthly_listener_count,
    al.month,

    CASE
        WHEN al.total_listeners > 0
        THEN (al.monthly_listener_count::numeric / al.total_listeners) * al.artist_base_payment
        ELSE 0
    END AS base_payment_share,

    (al.monthly_listener_count::numeric / 200) * 5.00 AS listener_bonus_payment,

    CASE
        WHEN al.total_listeners > 0
        THEN ((al.monthly_listener_count::numeric / al.total_listeners) * al.artist_base_payment) +
             ((al.monthly_listener_count::numeric / 200) * 5.00)
        ELSE (al.monthly_listener_count::numeric / 200) * 5.00
    END AS total_payment,

    al.total_revenue
FROM
    artist_listeners al
JOIN
    mustream_schm.users u ON al.user_id = u.user_id
ORDER BY
    al.month DESC, total_payment DESC;

CREATE TABLE mustream_schm.payment_records (
    payment_record_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    role TEXT NOT NULL,
    month DATE NOT NULL,
    payment_amount DECIMAL(15,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status TEXT DEFAULT 'pending',

    CONSTRAINT fk_payment_record_user FOREIGN KEY (user_id)
        REFERENCES mustream_schm.users(user_id) ON DELETE CASCADE,

    CONSTRAINT uq_user_month_payment UNIQUE (user_id, month)
);

/*NOTE might not need it*/
/*
function
CREATE OR REPLACE FUNCTION mustream_schm.generate_all_payments(payment_month DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT
        user_id, 'developer', month, individual_payment
    FROM
        mustream_schm.developer_payments_view
    WHERE
        month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT
        user_id, 'management', month, individual_payment
    FROM
        mustream_schm.management_payments_view
    WHERE
        month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

    INSERT INTO mustream_schm.payment_records (user_id, role, month, payment_amount)
    SELECT
        user_id, 'artist', month, total_payment
    FROM
        mustream_schm.artist_detailed_payments_view
    WHERE
        month = payment_month
    ON CONFLICT (user_id, month)
    DO UPDATE SET payment_amount = EXCLUDED.payment_amount;

END;
$$ LANGUAGE plpgsql;


EXECUTE
-- 1 make sure you have revenue and payment distribution data for the month
INSERT INTO mustream_schm.revenue_tracking (month, ad_revenue, subscription_revenue)
VALUES ('2025-02-01', 10000.00, 8000.00);

INSERT INTO mustream_schm.payment_distribution
(revenue_id, month, ad_revenue, subscription_revenue, total_revenue)
SELECT revenue_id, month, ad_revenue, subscription_revenue, total_revenue
FROM mustream_schm.revenue_tracking
WHERE month = '2025-02-01';

-- 2 view payments for each role
SELECT * FROM mustream_schm.developer_payments_view WHERE month = '2025-02-01';
SELECT * FROM mustream_schm.management_payments_view WHERE month = '2025-02-01';
SELECT * FROM mustream_schm.artist_detailed_payments_view WHERE month = '2025-02-01';

-- 3 generate official payment records for all roles
SELECT mustream_schm.generate_all_payments('2025-02-01');

-- 4 check the payment records
SELECT * FROM mustream_schm.payment_records WHERE month = '2025-02-01';


SELECT mustream_schm.generate_all_payments('2025-02-01');
-- 5 check the payment records
SELECT * FROM mustream_schm.payment_records WHERE month = '2025-02-01';



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
*/