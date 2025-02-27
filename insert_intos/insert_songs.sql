INSERT INTO mustream_schm.songs (artist_id, song_name, genre, listeners_count, date_created, copyright_owner)
VALUES
    -- DJ Creator1 (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Beat Drop', 'Electronic', 12000, DEFAULT, 'ElectroBeats Records'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Night Vibes', 'House', 8900, DEFAULT, 'DJ Creator1'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'DJ Creator1'), 'Bass Revolution', 'EDM', 9700, DEFAULT, 'BassBoost Inc.'),

    -- BeatsByC2 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'BeatsByC2'), 'Summer Breeze', 'Pop', 6800, DEFAULT, 'BeatsByC2'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'BeatsByC2'), 'Feel The Rhythm', 'Dance', 7400, DEFAULT, 'PopMasters'),

    -- SoundMaster3 (4 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Retro Waves', 'Synthwave', 10200, DEFAULT, 'Retro Records'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'City Lights', 'Synthwave', 8900, DEFAULT, 'SynthLord6'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Dream Machine', 'Electronic', 7500, DEFAULT, 'SoundMaster3'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SoundMaster3'), 'Futuristic Sound', 'Techno', 9800, DEFAULT, 'ElectroVibes'),

    -- C4 Vibes (1 Song)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'C4 Vibes'), 'Bassline Madness', 'House', 5600, DEFAULT, 'C4 Vibes'),

    -- The WaveMaker (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Ocean Vibes', 'Chill', 7200, DEFAULT, 'WaveSounds'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Deep Sea', 'Ambient', 8300, DEFAULT, 'The WaveMaker'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'The WaveMaker'), 'Sunset Dreams', 'Lounge', 9100, DEFAULT, 'ChillBeats Inc.'),

    -- SynthLord6 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SynthLord6'), 'Neon Dreams', 'Synthwave', 6000, DEFAULT, 'SynthLord6'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'SynthLord6'), 'Cyber Groove', 'Electronic', 8700, DEFAULT, 'CyberBeats'),

    -- Rockstar7 (4 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Guitar Hero', 'Rock', 9900, DEFAULT, 'Rock Legends'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Stadium Anthem', 'Hard Rock', 7800, DEFAULT, 'Rockstar7'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Power Chords', 'Metal', 8600, DEFAULT, 'MetalHeads'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'Rockstar7'), 'Acoustic Soul', 'Folk Rock', 7500, DEFAULT, 'Acoustic Records'),

    -- ChillBeats8 (1 Song)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'ChillBeats8'), 'Mellow Nights', 'Lo-Fi', 5300, DEFAULT, 'Lo-Fi Lounge'),

    -- HipHopKing9 (3 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Spit Fire', 'Hip-Hop', 11800, DEFAULT, 'HipHopWorld'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Street Vibes', 'Rap', 9400, DEFAULT, 'HipHopKing9'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'HipHopKing9'), 'Golden Age', 'Old School', 8700, DEFAULT, 'Classic Hip-Hop'),

    -- IndieSoul10 (2 Songs)
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'IndieSoul10'), 'Lost in Time', 'Indie', 6500, DEFAULT, 'IndieSoul10'),
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'IndieSoul10'), 'Dreamy Escape', 'Alternative', 7200, DEFAULT, 'IndieVibes');