-------------------- PART 3 ----------------------------------------
-- Run the movies scripts first:
-- -- movies_schema.sql
-- -- movies_data.sql

-- NOTE: SQLite doesn't support extensions like PostgreSQL
-- The following PostgreSQL extensions are not available:
-- tablefunc, fuzzystrmatch, cube

-- Like and LIKE (SQLite is case sensitive by default, LIKE is case insensitive in SQLite)
SELECT title FROM movies WHERE title LIKE 'stardust%';
SELECT title FROM movies WHERE title LIKE 'star%';
SELECT title FROM movies WHERE title LIKE 'stard___';

-- Regex in SQLite uses REGEXP (requires loading regex extension or use GLOB/LIKE)
-- SQLite REGEXP requires enabling it, so using LIKE/GLOB instead
SELECT COUNT(*) FROM movies WHERE title NOT LIKE 'the%';

-- LEVENSHTEIN - Not available in SQLite without custom function
-- You would need to create a custom function or use a third party extension
-- Commenting out for now
-- SELECT 'kitten', 'sitting', LEVENSHTEIN('kitten', 'sitting');
-- SELECT movie_id, title FROM movies WHERE levenshtein(lower(title), 'a hard day nght') < 3;


-- Full Text Search - SQLite has FTS5 but syntax is very different
-- Basic search