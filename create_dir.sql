CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    userid TEXT NOT NULL,
    dtstart DATE DEFAULT '1900-01-01',
    dtend DATE DEFAULT '9999-12-31'
);


CREATE TABLE tracks (
    id SERIAL PRIMARY KEY,
    track TEXT NOT NULL,
    dtstart DATE DEFAULT '1900-01-01',
    dtend DATE DEFAULT '9999-12-31'
);

CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    artist TEXT NOT NULL,
    dtstart DATE DEFAULT '1900-01-01',
    dtend DATE DEFAULT '9999-12-31'
);

CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    genre TEXT NOT NULL,
    dtstart DATE DEFAULT '1900-01-01',
    dtend DATE DEFAULT '9999-12-31'
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    city TEXT NOT NULL,
    dtstart DATE DEFAULT '1900-01-01',
    dtend DATE DEFAULT '9999-12-31'
);

CREATE TABLE music_facts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    track_id INT REFERENCES tracks(id),
    artist_id INT REFERENCES artists(id),
    genre_id INT REFERENCES genres(id),
    city_id INT REFERENCES cities(id),
    time FLOAT8,
    report_date TIMESTAMP,
    weekday_ TIMESTAMP
);

ALTER TABLE users ADD CONSTRAINT unique_userid UNIQUE (userid);
ALTER TABLE tracks ADD CONSTRAINT unique_tracks UNIQUE (track);
ALTER TABLE artists ADD CONSTRAINT unique_artists UNIQUE (artist);
ALTER TABLE genres ADD CONSTRAINT unique_genres UNIQUE (genre);
ALTER TABLE cities ADD CONSTRAINT unique_cities UNIQUE (city);
