-- Media Database Sample Data and Queries
-- English Version

USE Media;

-- Insert sample data into Genres table
INSERT INTO Genre(Name_Genre) VALUES 
('Comedy'), ('Thriller'), ('Crime'), ('Action'), 
('Horror'), ('Drama'), ('Sci-Fi'), ('Romance');

-- Insert media types
INSERT INTO MediaType(Type_Name) VALUES 
('Cinema'), ('Series'), ('Anime'), ('Cartoon'),
('Documentary'), ('Short Film');

-- Insert sample media
INSERT INTO Media(Title, Description, Awards, ReleaseDate, Score, GenreId, TypeId, Duration, Language)
VALUES 
('The Dark Knight', 'Batman faces the Joker', '2 Oscars', '2008-07-18', 9, 4, 1, 152, 'English'),
('Inception', 'A thief who steals corporate secrets', '4 Oscars', '2010-07-16', 8, 4, 1, 148, 'English'),
('Breaking Bad', 'A high school chemistry teacher diagnosed with cancer', '16 Emmys', '2008-01-20', 9, 3, 2, 45, 'English'),
('Stranger Things', 'When a young boy vanishes, a small town uncovers a mystery', '7 Emmys', '2016-07-15', 8, 6, 2, 50, 'English'),
('Your Name', 'Two teenagers share a profound connection', 'Best Animated Feature', '2016-08-26', 8, 7, 3, 106, 'Japanese');

-- Insert sample people
INSERT INTO Person(FullName) VALUES 
('Christopher Nolan'), ('Heath Ledger'), ('Bryan Cranston'),
('Vince Gilligan'), ('Matt Duffer'), ('Makoto Shinkai');

-- Insert professions
INSERT INTO Profession(ProfessionName) VALUES 
('Director'), ('Actor'), ('Writer'), ('Producer'),
('Cinematographer'), ('Composer');

-- Connect people to media with their professions
INSERT INTO MediaPerson(MediaId, PersonId, ProfessionId) VALUES
(1, 1, 1), (1, 2, 2), (2, 1, 1), 
(3, 3, 2), (3, 4, 3), (4, 5, 1),
(5, 6, 1);

-- Insert subscription types
INSERT INTO SubscriptionType(SubscriptionName) VALUES
('Inactive'), ('Basic'), ('Premium'), ('Family'),
('Student'), ('Annual');

-- Insert sample users
INSERT INTO [User](FirstName, LastName, Username, Phone, PasswordHash, Email, Bio, SubscriptionTypeId)
VALUES
('John', 'Doe', 'johndoe', '1234567890', 'hashedpassword1', 'john@example.com', 'Movie enthusiast', 3),
('Jane', 'Smith', 'janesmith', '0987654321', 'hashedpassword2', 'jane@example.com', 'Series binge-watcher', 2),
('Mike', 'Johnson', 'mikej', '1122334455', 'hashedpassword3', 'mike@example.com', 'Anime fan', 5);

-- Insert comments
INSERT INTO Comment(CommentText, UserId, MediaId) VALUES
('Amazing movie with great performances!', 1, 1),
('The plot twist was mind-blowing!', 2, 2),
('Best series I have ever watched!', 3, 3),
('The animation was beautiful', 1, 5);

-- Track watched media
INSERT INTO WatchedMedia(UserId, MediaId) VALUES
(1, 1), (1, 2), (1, 5),
(2, 2), (2, 4),
(3, 3), (3, 5);

-- Sample Queries

-- 1. Media that no one has watched
SELECT Title, MediaId 
FROM Media 
WHERE MediaId NOT IN (SELECT MediaId FROM WatchedMedia);

-- 2. Media watched more than once
SELECT m.Title, m.MediaId, COUNT(w.UserId) AS ViewCount
FROM Media m
INNER JOIN WatchedMedia w ON m.MediaId = w.MediaId
GROUP BY m.Title, m.MediaId
HAVING COUNT(w.UserId) >= 2;

-- 3. Top 3 most watched media
SELECT TOP 3 m.Title, COUNT(w.UserId) AS ViewCount
FROM Media m
INNER JOIN WatchedMedia w ON m.MediaId = w.MediaId
GROUP BY m.Title
ORDER BY ViewCount DESC;

-- 4. Most popular genre
SELECT TOP 1 g.Name_Genre, COUNT(w.UserId) AS ViewCount
FROM Media m
INNER JOIN WatchedMedia w ON m.MediaId = w.MediaId
INNER JOIN Genre g ON m.GenreId = g.GenreId
GROUP BY g.Name_Genre
ORDER BY ViewCount DESC;

-- 5. Activate inactive subscriptions
UPDATE [User] 
SET SubscriptionTypeId = 2 
WHERE SubscriptionTypeId IN (
    SELECT SubscriptionTypeId FROM SubscriptionType WHERE SubscriptionName = 'Inactive'
);

-- 6. Delete comedy media
DELETE FROM Media 
WHERE GenreId IN (SELECT GenreId FROM Genre WHERE Name_Genre = 'Comedy');

-- 7. Get all comments by a specific user
SELECT u.Username, m.Title, c.CommentText
FROM Comment c
INNER JOIN [User] u ON c.UserId = u.UserId
INNER JOIN Media m ON c.MediaId = m.MediaId
WHERE u.Username = 'johndoe';

-- 8. Count media by genre
SELECT g.Name_Genre, COUNT(m.MediaId) AS MediaCount
FROM Genre g
LEFT JOIN Media m ON g.GenreId = m.GenreId
GROUP BY g.Name_Genre;

-- 9. Find all media by a specific director
SELECT m.Title, m.ReleaseDate, m.Score
FROM Media m
INNER JOIN MediaPerson mp ON m.MediaId = mp.MediaId
INNER JOIN Person p ON mp.PersonId = p.PersonId
INNER JOIN Profession pr ON mp.ProfessionId = pr.ProfessionId
WHERE p.FullName = 'Christopher Nolan' AND pr.ProfessionName = 'Director';

-- 10. Users with premium subscriptions
SELECT FirstName, LastName, Username, Email
FROM [User] u
INNER JOIN SubscriptionType s ON u.SubscriptionTypeId = s.SubscriptionTypeId
WHERE s.SubscriptionName = 'Premium';

-- Change subscription type to 'Premium' for user 'janesmith'
UPDATE [User]
SET SubscriptionTypeId = 3
WHERE Username = 'janesmith';


-- Delete media titled 'Your Name'
DELETE FROM Media
WHERE Title = 'Your Name';
