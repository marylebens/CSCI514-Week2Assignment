-------------------- PART 3 ----------------------------------------
-- Run the movies scripts first:
-- -- movies_schema.sql
-- -- movies_data.sql

--Install pacakges
create extension if not exists tablefunc
create extension if not exists fuzzystrmatch
create extension if not exists cube

select * from pg_extension where extname = 'tablefunc'
-- Like and ILIKE
select title from movies where title ilike 'stardust%'
select title from movies where title ilike 'star%'
select title from movies where title ilike 'stard___'

--regex
SELECT COUNT(*) FROM movies WHERE title !~* '^the.*';

--LEVENSHTEIN
SELECT 'kitten', 'sitting', LEVENSHTEIN('kitten', 'sitting')
SELECT movie_id, title FROM movies WHERE levenshtein(lower(title), 'a hard day nght') < 3;


-- Full Text and multidimensions
select title, to_tsvector(title) from movies; 

Select title 
from movies
where title @@ 'night & day';

--cube
select name, cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) as score
from genres G
where cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;

select *, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
from movies
order by dist;

CREATE TABLE spatial_data (
    id serial PRIMARY KEY,
    point_data cube
);

INSERT INTO spatial_data (point_data) VALUES ('(1, 2, 3)');
INSERT INTO spatial_data (point_data) VALUES ('(4, 5, 6)');
-- You can insert more data as needed

-- Calculate the distance between two 3D points
-- the <-> operator calculates the distance between the stored 3D points and the specified point (2, 3, 4).
SELECT point_data <-> '(2, 3, 4)' AS distance
FROM spatial_data;


-- 1. Size of the Table Including All Indexes
SELECT pg_size_pretty(pg_total_relation_size('your_table_name')) AS total_size;
-- 2. Size of the Table Alone (Excluding Indexes)
SELECT pg_size_pretty(pg_relation_size('your_table_name')) AS table_size;
-- 3. Size of the Indexes Only
SELECT pg_size_pretty(pg_indexes_size('your_table_name')) AS indexes_size;
-- 4. Size of All Tables in the Database
SELECT 
    table_name, 
    pg_size_pretty(pg_total_relation_size(table_name)) AS total_size
FROM 
    information_schema.tables
WHERE 
    table_schema = 'public'  -- Adjust schema name if needed
ORDER BY 
    pg_total_relation_size(table_name) DESC;
-- 5. Detailed Breakdown by Table and Index
SELECT
    table_name,
    pg_size_pretty(pg_relation_size(table_name)) AS table_size,
    pg_size_pretty(pg_total_relation_size(table_name) - pg_relation_size(table_name)) AS indexes_size
FROM
    information_schema.tables
WHERE
    table_schema = 'public'  -- Adjust schema name if needed
ORDER BY
    pg_total_relation_size(table_name) DESC;
