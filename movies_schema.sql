DROP TABLE movies;
DROP TABLE actors;
DROP TABLE movies_actors;
DROP TABLE genres;

CREATE TABLE movies ( movie_id INTEGER PRIMARY KEY, title TEXT, genre TEXT ); CREATE TABLE actors ( actor_id INTEGER PRIMARY KEY, name TEXT ); CREATE TABLE movies_actors ( movie_id INTEGER NOT NULL REFERENCES movies(movie_id), actor_id INTEGER NOT NULL REFERENCES actors(actor_id), UNIQUE (movie_id, actor_id) ); CREATE TABLE genres ( name TEXT UNIQUE, position INTEGER ); CREATE INDEX movies_actors_movie_id ON movies_actors (movie_id); CREATE INDEX movies_actors_actor_id ON movies_actors (actor_id); CREATE INDEX movies_genre_idx ON movies (genre);