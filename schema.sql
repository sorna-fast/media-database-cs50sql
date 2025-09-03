-- Create Media database
CREATE DATABASE Media;
GO

USE Media;

-- Genre table (English name)
CREATE TABLE Genre(
    GenreId TINYINT PRIMARY KEY IDENTITY NOT NULL,
    Name_Genre NVARCHAR(50) NOT NULL
);

-- Media type table (English name)
CREATE TABLE MediaType(
    TypeId TINYINT PRIMARY KEY IDENTITY NOT NULL,
    Type_Name NVARCHAR(50) NOT NULL
);

-- Main media table (English name with compatible columns)
CREATE TABLE Media(
    MediaId BIGINT PRIMARY KEY IDENTITY NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Awards NVARCHAR(100) NULL,
    ReleaseDate DATE NULL,
    Score TINYINT NULL,
    GenreId TINYINT NULL,
    TypeId TINYINT NULL,
    Duration SMALLINT NULL,
    Language NVARCHAR(50) NULL,
    FOREIGN KEY (GenreId) REFERENCES Genre(GenreId) ON DELETE SET NULL,
    FOREIGN KEY (TypeId) REFERENCES MediaType(TypeId) ON DELETE SET NULL
);

-- People table (English name)
CREATE TABLE Person(
    PersonId INT PRIMARY KEY IDENTITY NOT NULL,
    FullName NVARCHAR(100) NOT NULL
);

-- Professions table (English name)
CREATE TABLE Profession(
    ProfessionId INT PRIMARY KEY IDENTITY NOT NULL,
    ProfessionName NVARCHAR(50) NOT NULL
);

-- Relationship between people and media (English name)
CREATE TABLE MediaPerson(
    MediaPersonId BIGINT PRIMARY KEY IDENTITY NOT NULL,
    MediaId BIGINT NULL,
    PersonId INT NULL,
    ProfessionId INT NULL,
    FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
    FOREIGN KEY (ProfessionId) REFERENCES Profession(ProfessionId),
    FOREIGN KEY (MediaId) REFERENCES Media(MediaId)
);

-- Subscription types table (English name)
CREATE TABLE SubscriptionType(
    SubscriptionTypeId TINYINT PRIMARY KEY IDENTITY NOT NULL,
    SubscriptionName NVARCHAR(50) NOT NULL
);

-- Users table (English name with compatible columns)
CREATE TABLE [User](
    UserId INT PRIMARY KEY IDENTITY NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Bio NVARCHAR(MAX) NULL,
    SubscriptionTypeId TINYINT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubscriptionTypeId) REFERENCES SubscriptionType(SubscriptionTypeId) ON DELETE SET NULL
);

-- Comments table (English name)
CREATE TABLE Comment(
    CommentId BIGINT PRIMARY KEY IDENTITY NOT NULL,
    CommentText NVARCHAR(MAX) NOT NULL,
    UserId INT NULL,
    MediaId BIGINT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES [User](UserId) ON DELETE CASCADE,
    FOREIGN KEY (MediaId) REFERENCES Media(MediaId) ON DELETE CASCADE
);

-- Watched media table (English name)
CREATE TABLE WatchedMedia(
    WatchedMediaId INT PRIMARY KEY IDENTITY NOT NULL,
    UserId INT NOT NULL,
    MediaId BIGINT NOT NULL,
    WatchedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES [User](UserId) ON DELETE CASCADE,
    FOREIGN KEY (MediaId) REFERENCES Media(MediaId) ON DELETE CASCADE
);