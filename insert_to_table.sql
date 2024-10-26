CREATE OR REPLACE PROCEDURE p_ins(
    date1 TIMESTAMP,
    date2 TIMESTAMP
)

LANGUAGE plpgsql AS $$
BEGIN
truncate users, tracks, artists, genres, cities, music_facts;
    -- Вставка пользователей
    INSERT INTO users (userid)
        SELECT DISTINCT userid
        FROM target_table
        ON CONFLICT (userid) DO NOTHING;

    -- Вставка треков
    INSERT INTO tracks (track)
        SELECT DISTINCT track
        FROM target_table
        ON CONFLICT (track) DO NOTHING;

    -- Вставка исполнителей
    INSERT INTO artists (artist)
        SELECT DISTINCT artist
        FROM target_table
        ON CONFLICT (artist) DO NOTHING;

    -- Вставка жанров
    INSERT INTO genres (genre)
        SELECT DISTINCT genre
        FROM target_table
        ON CONFLICT (genre) DO NOTHING;

    -- Вставка городов
    INSERT INTO cities (city)
        SELECT DISTINCT city
        FROM target_table
        ON CONFLICT (city) DO NOTHING;

    -- Вставка фактов в таблицу music_facts
    INSERT INTO music_facts (user_id, track_id, artist_id, genre_id, city_id, time, "report_date", "weekday_")
    SELECT 
        u.id AS user_id,
        t.id AS track_id,
        a.id AS artist_id,
        g.id AS genre_id,
        c.id AS city_id,
        m.time,
        m."Report_date",
        m."Weekday"
    FROM target_table m
    LEFT JOIN users u ON m.userid = u.userid
    LEFT JOIN tracks t ON m.track = t.track
    LEFT JOIN artists a ON m.artist = a.artist
    LEFT JOIN genres g ON m.genre = g.genre
    LEFT JOIN cities c ON m.city = c.city
    WHERE m."Report_date" BETWEEN date1 AND date2;
END;
$$;

CALL p_ins('2023-01-01', '2023-12-31');
