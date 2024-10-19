CREATE TABLE target_table (
    id float8,
    userID text,
    track text,
    artist text,
    genre text,
    city text,
    time float8,
    "Report_date" timestamp,
    "Weekday" timestamp
);

CREATE OR REPLACE FUNCTION transfer_good_data(start_date timestamp, end_date timestamp)
RETURNS void AS $$
BEGIN
   INSERT INTO target_table ("id", "userid", "track", artist, genre, city, time, "Report_date", "Weekday")
   SELECT "ID", "userID", "Track", artist, genre, "City", time, "Report_date", "Weekday"
   FROM table1
   WHERE "Report_date" BETWEEN start_date AND end_date
     AND NOT ("ID" IS NULL AND "userID" IS NULL AND "Track" IS NULL 
              AND artist IS NULL AND genre IS NULL 
              AND "City" IS NULL AND time IS NULL 
              AND "Report_date" IS NULL AND "Weekday" IS NULL)
     AND "Report_date" IS NOT NULL;
   
END;
$$ LANGUAGE plpgsql;

SELECT transfer_good_data('2023-01-01'::TIMESTAMP, '2023-12-31'::TIMESTAMP);
