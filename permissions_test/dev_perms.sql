-- first log in as 1 of the developers current log in dev1: dev1pass
-- insert a new song
INSERT INTO mustream_schm.songs (artist_id, song_name, genre_id, listeners_count, date_created, copyright_owner)
VALUES
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'ChillBeats8'), 'We good', 5, 11000, DEFAULT, 'ElectroBeats Records');

-- Update an artist's name
UPDATE mustream_schm.artists
SET artist_name = 'THE WaveMaker'
WHERE artist_id = 5;

-- Delete a subscription record
DELETE FROM mustream_schm.subscription
WHERE subscription_id = 10;

-- Select all users
SELECT * FROM mustream_schm.users;
