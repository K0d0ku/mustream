INSERT INTO mustream_schm.ad_logs (ad_id, views, log_date)
VALUES
    -- Super Bass Headphones
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Super Bass Headphones'), 5000, DEFAULT),
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Super Bass Headphones'), 7200, DEFAULT),

    -- Unlimited Music Streaming
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Unlimited Music Streaming'), 8900, DEFAULT),
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Unlimited Music Streaming'), 10200, DEFAULT),

    -- Concert Ticket Giveaway
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Concert Ticket Giveaway'), 4500, DEFAULT),

    -- New Album Release: ElectroBeats
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'New Album Release: ElectroBeats'), 11000, DEFAULT),
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'New Album Release: ElectroBeats'), 7600, DEFAULT),

    -- AI-Powered DJ Software
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'AI-Powered DJ Software'), 6000, DEFAULT),

    -- Premium Sound Systems
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Premium Sound Systems'), 13000, DEFAULT),
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Premium Sound Systems'), 9400, DEFAULT),

    -- Virtual Festival Experience
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Virtual Festival Experience'), 7200, DEFAULT),

    -- Music Production Masterclass
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Music Production Masterclass'), 5600, DEFAULT),

    -- Exclusive Merch Drop
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Exclusive Merch Drop'), 8100, DEFAULT),

    -- Limited Edition Vinyl Records
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Limited Edition Vinyl Records'), 4800, DEFAULT),
    ((SELECT ad_id FROM mustream_schm.ads WHERE ad_name = 'Limited Edition Vinyl Records'), 7300, DEFAULT);