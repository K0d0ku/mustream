-- first log in as 1 of the creators, current log in is creator10
-- Insert a new song (Allowed)
INSERT INTO mustream_schm.songs (artist_id, song_name, genre_id, listeners_count, date_created, copyright_owner)
VALUES
    ((SELECT artist_id FROM mustream_schm.artists WHERE artist_name = 'IndieSoul10'), 'cascade', 6, 8000, DEFAULT, 'Warning sisters');

-- Update song details (Allowed)
UPDATE mustream_schm.songs
SET song_name = 'dreamy escape re'
WHERE song_id = 100 AND artist_id IN (
    SELECT artist_id FROM mustream_schm.artists
    WHERE user_id = current_user::INT
);
-- Attempt to delete own song (Allowed via RLS)
DELETE FROM mustream_schm.songs
WHERE song_id = 7;

-- Select all artists (Allowed)
SELECT * FROM mustream_schm.artists;

-- Attempting access to payment records (Not Allowed)
SELECT * FROM mustream_schm.payment_records;
