-- begin transaction
BEGIN;

-- set variables
DO $$
DECLARE
    current_month DATE := DATE_TRUNC('month', CURRENT_DATE);
    previous_month DATE := DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month');
    process_result BOOLEAN;
BEGIN
    -- output processing information
    RAISE NOTICE 'Starting payment processing for month: %', TO_CHAR(previous_month, 'YYYY-MM');

    -- call the update function for the previous month
    PERFORM mustream_schm.update_monthly_payments(previous_month);

    -- log the payment processing
    INSERT INTO mustream_schm.payment_logs (
        log_date,
        log_message
    ) VALUES (
        CURRENT_TIMESTAMP,
        'Monthly payments processed for ' || TO_CHAR(previous_month, 'YYYY-MM') ||
        ' (manually triggered)'
    );

    -- output success message
    RAISE NOTICE 'Payment processing completed successfully';
    RAISE NOTICE 'Details:';

    -- output summary of processed payments
    FOR process_result IN
        SELECT TRUE FROM mustream_schm.payments
        WHERE payment_date = previous_month
    LOOP
        RAISE NOTICE '  - Payment record exists for %', TO_CHAR(previous_month, 'YYYY-MM');

        -- display payment amounts
        RAISE NOTICE '  - Total revenue: $%',
            (SELECT total_revenue FROM mustream_schm.payments WHERE payment_date = previous_month);
        RAISE NOTICE '  - Developer payment: $%',
            (SELECT dev_payment FROM mustream_schm.payments WHERE payment_date = previous_month);
        RAISE NOTICE '  - Management payment: $%',
            (SELECT management_payment FROM mustream_schm.payments WHERE payment_date = previous_month);
        RAISE NOTICE '  - Creator payment: $%',
            (SELECT creator_payment FROM mustream_schm.payments WHERE payment_date = previous_month);
    END LOOP;

    -- if no record found
    IF NOT FOUND THEN
        RAISE WARNING 'No payment record was created. Check for errors or data availability.';
    END IF;
END $$;

-- commit transaction
COMMIT;

-- output next steps
DO $$
BEGIN
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '  1. Review payment details in mustream_schm.payments';
    RAISE NOTICE '  2. Check logs in mustream_schm.payment_logs';
    RAISE NOTICE '  3. Schedule this script for next month or set up automation';
END $$;


-- to execute the query:
-- -- /*EXECUTE 3*/ first process the monthly payment calculation
SELECT mustream_schm.update_monthly_payments('2025-02-01');
CALL mustream_schm.process_monthly_payments();
/*if 3 has been done*/
SELECT mustream_schm.process_payment_for_month('2025-02-01');

-- -- /*EXECUTE 4*/ distribute to all user types
CALL mustream_schm.distribute_all_payments('2025-02-01');
-- -- or distribute to specific groups
SELECT mustream_schm.distribute_developer_payments('2025-02-01');
SELECT mustream_schm.distribute_management_payments('2025-02-01');
SELECT mustream_schm.distribute_creator_payments('2025-02-01');
--
-- -- /*EXECUTE 5*/ view all payments
SELECT * FROM mustream_schm.detailed_payments_view
WHERE payment_date = '2025-02-01'
ORDER BY payment_type, payment_amount DESC;
--
SELECT * FROM mustream_schm.payment_logs ORDER BY log_date DESC;

-- -- view just developer payments
SELECT * FROM mustream_schm.developer_payments
WHERE payment_date = '2025-02-27';