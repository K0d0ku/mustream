INSERT INTO mustream_schm.artists (user_id, artist_name, real_name, joined_date, monthly_listener_count)
VALUES
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator1'), 'DJ Creator1', 'John Doe', DEFAULT, 1000),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator2'), 'BeatsByC2', 'Jane Smith', DEFAULT, 5000),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator3'), 'SoundMaster3', 'Robert Johnson', DEFAULT, 2500),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator4'), 'C4 Vibes', 'Emily Davis', DEFAULT, 1200),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator5'), 'The WaveMaker', 'Michael Brown', DEFAULT, 3200),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator6'), 'SynthLord6', 'Sarah Wilson', DEFAULT, 800),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator7'), 'Rockstar7', 'David Martinez', DEFAULT, 2700),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator8'), 'ChillBeats8', 'Sophia Taylor', DEFAULT, 1800),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator9'), 'HipHopKing9', 'Daniel Anderson', DEFAULT, 6000),
    ((SELECT user_id FROM mustream_schm.users WHERE username = 'creator10'), 'IndieSoul10', 'Olivia Thomas', DEFAULT, 2200);
