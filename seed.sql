INSERT INTO users (id, username, email, password_hash, role)
VALUES
(UUID(), 'alice', 'alice@example.com', 'hashed_password_1', 'Client'),
(UUID(), 'bob', 'bob@example.com', 'hashed_password_2', 'Client'),
(UUID(), 'charlie', 'charlie@example.com', 'hashed_password_3', 'Client'),
(UUID(), 'diana', 'diana@example.com', 'hashed_password_4', 'Client'),
(UUID(), 'admin', 'admin@example.com', 'hashed_password_5', 'Admin');

INSERT INTO profiles (id, user_id, name, category, photo_url)
SELECT
UUID(), id, 'Alice Main', 'Default', 'https://example.com/photos/alice.jpg' FROM users WHERE username='alice'
UNION ALL
SELECT UUID(), id, 'Bob Junior', 'Kids', 'https://example.com/photos/bob.jpg' FROM users WHERE username='bob'
UNION ALL
SELECT UUID(), id, 'Charlie Main', 'Default', 'https://example.com/photos/charlie.jpg' FROM users WHERE username='charlie'
UNION ALL
SELECT UUID(), id, 'Diana Main', 'Default', 'https://example.com/photos/diana.jpg' FROM users WHERE username='diana'
UNION ALL
SELECT UUID(), id, 'Admin Main', 'Default', 'https://example.com/photos/admin.jpg' FROM users WHERE username='admin';

INSERT INTO languages (id, iso_code, name)
VALUES
(UUID(), 'en', 'English'),
(UUID(), 'pt', 'Portuguese'),
(UUID(), 'es', 'Spanish'),
(UUID(), 'fr', 'French'),
(UUID(), 'ja', 'Japanese'),
(UUID(), 'it', 'Italian');

INSERT INTO genres (id, name)
VALUES
(UUID(), 'Action'),
(UUID(), 'Comedy'),
(UUID(), 'Drama'),
(UUID(), 'Fantasy'),
(UUID(), 'Sci-Fi');

INSERT INTO movies (id, title, description, director, release_year, duration_minutes, rating, indicative_classification, cover_image)
VALUES
(UUID(), 'Sky Warriors', 'A group of elite pilots fights to save the world.', 'James Hunter', 2022, 120, 4.5, '12', 'https://example.com/covers/skywarriors.jpg'),
(UUID(), 'Love & Laughter', 'A romantic comedy about life in a small town.', 'Marie Collins', 2021, 98, 4.0, '10', 'https://example.com/covers/lovelaughter.jpg'),
(UUID(), 'Hidden Truth', 'A gripping drama about family secrets.', 'Alan Brooks', 2020, 110, 4.2, '14', 'https://example.com/covers/hiddentruth.jpg'),
(UUID(), 'The Crystal Realm', 'A fantasy adventure across magical lands.', 'Sophie Liu', 2019, 130, 4.6, '10', 'https://example.com/covers/crystalrealm.jpg'),
(UUID(), 'Neon Future', 'A cyberpunk sci-fi epic set in a dystopian city.', 'Kenji Takahashi', 2023, 125, 4.8, '16', 'https://example.com/covers/neonfuture.jpg');

INSERT INTO profile_preferred_languages (profile_id, language_id)
SELECT p.id, l.id
FROM profiles p
JOIN languages l ON l.iso_code IN ('en', 'pt')
WHERE p.name='Alice Main'
UNION ALL
SELECT p.id, l.id
FROM profiles p
JOIN languages l ON l.iso_code='es'
WHERE p.name='Bob Junior'
UNION ALL
SELECT p.id, l.id
FROM profiles p
JOIN languages l ON l.iso_code='en'
WHERE p.name IN ('Charlie Main', 'Diana Main', 'Admin Main');

INSERT INTO watch_histories (id, profile_id, movie_id, started_at, finished_at, progress_minutes)
SELECT UUID(), p.id, m.id, NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 2 DAY, 120
FROM profiles p
JOIN movies m ON (p.name='Alice Main' AND m.title='Sky Warriors')
UNION ALL
SELECT UUID(), p.id, m.id, NOW() - INTERVAL 5 DAY, NULL, 45
FROM profiles p
JOIN movies m ON (p.name='Bob Junior' AND m.title='Love & Laughter')
UNION ALL
SELECT UUID(), p.id, m.id, NOW() - INTERVAL 1 DAY, NOW(), 130
FROM profiles p
JOIN movies m ON (p.name='Charlie Main' AND m.title='The Crystal Realm');

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m, genres g
WHERE (m.title='Sky Warriors' AND g.name='Action')
UNION ALL SELECT m.id, g.id FROM movies m, genres g WHERE (m.title='Love & Laughter' AND g.name='Comedy')
UNION ALL SELECT m.id, g.id FROM movies m, genres g WHERE (m.title='Hidden Truth' AND g.name='Drama')
UNION ALL SELECT m.id, g.id FROM movies m, genres g WHERE (m.title='The Crystal Realm' AND g.name='Fantasy')
UNION ALL SELECT m.id, g.id FROM movies m, genres g WHERE (m.title='Neon Future' AND g.name='Sci-Fi');

INSERT INTO profile_movie_list (id, profile_id, movie_id)
SELECT UUID(), p.id, m.id
FROM profiles p
JOIN movies m ON (p.name='Alice Main' AND m.title IN ('Sky Warriors','Neon Future'))
UNION ALL
SELECT UUID(), p.id, m.id
FROM profiles p
JOIN movies m ON (p.name='Bob Junior' AND m.title='Love & Laughter')
UNION ALL
SELECT UUID(), p.id, m.id
FROM profiles p
JOIN movies m ON (p.name='Charlie Main' AND m.title='The Crystal Realm');

INSERT INTO subtitles (id, movie_id, language_id, file_hash, storage_link)
SELECT UUID(), m.id, l.id, MD5(CONCAT(m.title,l.iso_code)), CONCAT('https://cdn.example.com/subs/', m.title, '_', l.iso_code, '.vtt')
FROM movies m
JOIN languages l ON l.iso_code IN ('en','pt','es');

INSERT INTO movie_formats (id, movie_id, language_id, resolution, file_hash, storage_link)
SELECT UUID(), m.id, l.id, '1080p', MD5(CONCAT(m.title,'1080p')), CONCAT('https://cdn.example.com/', m.title, '_1080p.mp4')
FROM movies m
JOIN languages l ON l.iso_code='en'
UNION ALL
SELECT UUID(), m.id, l.id, '360p', MD5(CONCAT(m.title,'360p')), CONCAT('https://cdn.example.com/', m.title, '_360p.mp4')
FROM movies m
JOIN languages l ON l.iso_code='en';

INSERT INTO profile_favorites_genres (profile_id, genre_id)
SELECT p.id, g.id FROM profiles p
JOIN genres g ON g.name IN ('Action','Drama')
WHERE p.name='Alice Main'
UNION ALL
SELECT p.id, g.id FROM profiles p
JOIN genres g ON g.name='Comedy'
WHERE p.name='Bob Junior'
UNION ALL
SELECT p.id, g.id FROM profiles p
JOIN genres g ON g.name IN ('Fantasy','Sci-Fi')
WHERE p.name='Charlie Main';