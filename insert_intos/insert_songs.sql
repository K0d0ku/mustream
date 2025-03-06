INSERT INTO mustream_schm.songs (artist_id, song_name, genre_id, listeners_count, date_created, copyright_owner)
VALUES
    -- DJ Creator1 (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Beat Drop', 5, 12000, DEFAULT, 'ElectroBeats Records'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Night Vibes', 7, 8900, DEFAULT, 'DJ Creator1'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Bass Revolution', 10, 9700, DEFAULT, 'BassBoost Inc.'),

    -- BeatsByC2 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'BeatsByC2'), 'Summer Breeze', 1, 6800, DEFAULT, 'BeatsByC2'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'BeatsByC2'), 'Feel The Rhythm', 3, 7400, DEFAULT, 'PopMasters'),

    -- SoundMaster3 (4 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Retro Waves', 5, 10200, DEFAULT, 'Retro Records'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'City Lights', 9, 8900, DEFAULT, 'SynthLord6'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Dream Machine', 5, 7500, DEFAULT, 'SoundMaster3'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Futuristic Sound', 1, 9800, DEFAULT, 'ElectroVibes'),

    -- C4 Vibes (1 Song)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'C4 Vibes'), 'Bassline Madness', 4, 5600, DEFAULT, 'C4 Vibes'),

    -- The WaveMaker (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Ocean Vibes', 2, 7200, DEFAULT, 'WaveSounds'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Deep Sea', 10, 8300, DEFAULT, 'The WaveMaker'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Sunset Dreams', 4, 9100, DEFAULT, 'ChillBeats Inc.'),

    -- SynthLord6 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SynthLord6'), 'Neon Dreams', 7, 6000, DEFAULT, 'SynthLord6'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SynthLord6'), 'Cyber Groove', 5, 8700, DEFAULT, 'CyberBeats'),

    -- Rockstar7 (4 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Guitar Hero', 8, 9900, DEFAULT, 'Rock Legends'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Stadium Anthem', 8, 7800, DEFAULT, 'Rockstar7'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Power Chords', 8, 8600, DEFAULT, 'MetalHeads'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Acoustic Soul', 8, 7500, DEFAULT, 'Acoustic Records'),

    -- ChillBeats8 (1 Song)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'ChillBeats8'), 'Mellow Nights', 4, 5300, DEFAULT, 'Lo-Fi Lounge'),

    -- HipHopKing9 (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Spit Fire', 3, 11800, DEFAULT, 'HipHopWorld'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Street Vibes', 3, 9400, DEFAULT, 'HipHopKing9'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Golden Age', 7, 8700, DEFAULT, 'Classic Hip-Hop'),

    -- IndieSoul10 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'IndieSoul10'), 'Lost in Time', 7, 6500, DEFAULT, 'IndieSoul10'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'IndieSoul10'), 'Dreamy Escape', 10, 7200, DEFAULT, 'IndieVibes');