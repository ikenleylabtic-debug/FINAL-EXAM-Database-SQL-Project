Create Database First_database;

Create Database Second_Database;

USE First_database;

Create Table IF NOT EXISTS Profile_ (
    Profile_ID INT PRIMARY KEY,
    Name_ VARCHAR(100),
    Address VARCHAR(255),
    Age INT,
    Department VARCHAR(100),
    Position VARCHAR(100)
);

INSERT INTO Profile_ (Profile_ID, Name_, Address, Age, Department, Position) VALUES
(1, 'Juan Dela Cruz', 'Makati City', 25, 'IT', 'Programmer'),
(2, 'Maria Santos', 'Manila City', 28, 'HR', 'HR Officer'),
(3, 'Pedro Reyes', 'Pasig City', 30, 'Finance', 'Accountant'),
(4, 'Ana Garcia', 'Quezon City', 26, 'IT', 'Database Administrator'),
(5, 'Jose Ramos', 'Taguig City', 32, 'Marketing', 'Marketing Manager');

SELECT * FROM First_database.Profile_;

USE Second_Database;

CREATE TABLE Profile_ LIKE First_database.Profile_;

INSERT INTO Second_Database.Profile_
SELECT * FROM First_database.Profile_;

SELECT * FROM Second_Database.Profile_;

CREATE USER IF NOT EXISTS
'dbuser'@'localhost'
IDENTIFIED BY 'MyStrongPassword123!';

GRANT ALL PRIVILEGES ON Second_Database.*
TO 'dbuser'@'localhost';

FLUSH PRIVILEGES;

CREATE TABLE Profile_Encrypted (
    Profile_ID INT PRIMARY KEY,
    Name_ VARBINARY(255),
    Address VARBINARY(255),
    Age VARBINARY(255),
    Department VARBINARY(255),
    Position VARBINARY(255)
);

SET @encryption_key = 'MySecretKey123';

INSERT INTO Profile_Encrypted
(Profile_ID, Name_, Address, Age, Department, Position)
SELECT
    Profile_ID,
    AES_ENCRYPT(Name_, @encryption_key),
    AES_ENCRYPT(Address, @encryption_key),
    AES_ENCRYPT(CAST(Age AS CHAR), @encryption_key),
    AES_ENCRYPT(Department, @encryption_key),
    AES_ENCRYPT(Position, @encryption_key)
FROM Second_Database.Profile_;

SELECT
    Profile_ID,
    CAST(AES_DECRYPT(Name_, @encryption_key) AS CHAR) AS Name_,
    CAST(AES_DECRYPT(Address, @encryption_key) AS CHAR) AS Address,
    CAST(AES_DECRYPT(Age, @encryption_key) AS CHAR) AS Age,
    CAST(AES_DECRYPT(Department, @encryption_key) AS CHAR) AS Department,
    CAST(AES_DECRYPT(Position, @encryption_key) AS CHAR) AS Position
FROM Second_Database.Profile_Encrypted
WHERE Profile_ID IN (2, 3);

SELECT
    Profile_ID,
    HEX(Name_) AS Encrypted_Name,
    HEX(Address) AS Encrypted_Address,
    HEX(Age) AS Encrypted_Age,
    HEX(Department) AS Encrypted_Department,
    HEX(Position) AS Encrypted_Position
FROM Second_Database.Profile_Encrypted;

SELECT * FROM First_database.Profile_;

SELECT * FROM Second_Database.Profile_;

SELECT * FROM Second_Database.Profile_Encrypted;
