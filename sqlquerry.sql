-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
--EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min=0;

DELETE FROM spotify
WHERE duration_min=0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

--Q.1 retrieve the name of all tracks that have more than 1 biliion strems
SELECT * FROM spotify
WHERE stream > 1000000000

--Q>2 List all albums alongs with their respective artsts.
SELECT  DISTINCT album, artist FROM spotify
ORDER BY 1
--Q.3 get the total number off comments for tracks where licensed=TRUE
SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed = 'true'

--Q.4 find the all tracks that belog to the album type single
SELECT * FROM spotify
WHERE album_type='single'

--Q.5 count the total number of tracks by each artist.
SELECT artist, COUNT(*) as total_no_songs
FROM spotify
GROUP BY artist
ORDER BY 2

--Q.6 calculate the average danceability of tracks in each album.
SELECT album,avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

--Q.7 Find the top 5 tracks with the highest energy values.

SELECT track, Max(energy) FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.8 List all tracks along with their views and likes where official_video=TRUE.
SELECT track, 
SUM(views) as total_views,
SUM(likes) as total_views
FROM spotify
WHERE official_video='true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 For each album,calculate the total views of all associated tracks.
SELECT 
album,
track,
SUM(views) 
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC
--Q.10 Retrieve the track names taht have been stremed on Spotify more tahn YOutube

SELECT * FROM 
   (SELECT track,
   COALESCE(SUM(CASE WHEN most_played_on='Youtube' THEN stream END),0) as streamed_on_youtube,
   COALESCE(SUM(CASE WHEN most_played_on='Spotify' THEN stream END),0) as streamed_on_spotify
  FROM spotify
  GROUP BY 1 )
  as t1 
  WHERE 
  streamed_on_spotify > streamed_on_youtube
  AND 
  streamed_on_youtube <> 0

  --Q.11 Find the top 3 most-viewd tracks for each artist using window  functions.
WITH ranking_artist
AS
 (
 SELECT 
 artist,
 track, 
 SUM(views) as total_view,
 DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
 FROM spotify
 GROUP BY 1,2
 ORDER BY 1,3 DESC)
 SELECT * FROM ranking_artist
 WHERE rank<=3
--Q.12 write a query to find tacks where the liveness score is above the averege

   SELECT 
   track,
   artist,
   liveness
   FROM spotify
   WHERE liveness > (SELECT AVG(liveness) FROM spotify)
   






