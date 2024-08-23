CREATE TABLE Campers (
    CamperID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Gender CHAR(1),
    DateOfBirth DATE,
    PersonalPhone VARCHAR(15),
    Generation VARCHAR(20)
);

CREATE TABLE CampVisits (
    VisitID SERIAL PRIMARY KEY,
    CamperID INT REFERENCES Campers(CamperID),
    CampID INT,
    VisitDate DATE
);

INSERT INTO Campers (FirstName, MiddleName, LastName, Email, Gender, DateOfBirth, PersonalPhone, Generation)
SELECT 
    CASE 
        WHEN RANDOM() < 0.05 THEN 'Lakshmi'
        WHEN RANDOM() < 0.5 THEN 'Vikram' 
        ELSE 'Vivek' 
    END AS FirstName,
    CASE WHEN RANDOM() < 0.5 THEN 'A.' ELSE 'B.' END AS MiddleName,
    CASE WHEN RANDOM() < 0.5 THEN 'Sanjiv' ELSE 'Deva' END AS LastName,
    CONCAT(
        CASE WHEN RANDOM() < 0.5 THEN 'vikram' ELSE 'vivek' END,
        FLOOR(1000 + RANDOM() * 9000),
        '@example.com'
    ) AS Email,
    CASE 
        WHEN RANDOM() < 0.65 THEN 'F' 
        ELSE 'M' 
    END AS Gender,
    CURRENT_DATE - INTERVAL '3650 days' + INTERVAL '1 day' * FLOOR(RANDOM() * 3650) AS DateOfBirth,
    CONCAT('555-', FLOOR(1000 + RANDOM() * 9000)) AS PersonalPhone,
    CASE 
        WHEN EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '3650 days' + INTERVAL '1 day' * FLOOR(RANDOM() * 3650))) >= 2013 THEN 'Gen Alpha'
        WHEN EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '3650 days' + INTERVAL '1 day' * FLOOR(RANDOM() * 3650))) >= 1997 THEN 'Gen Z'
        WHEN EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '3650 days' + INTERVAL '1 day' * FLOOR(RANDOM() * 3650))) >= 1981 THEN 'Millennials'
        ELSE 'Gen X'
    END AS Generation
FROM 
    generate_series(1, 5000) AS s;

INSERT INTO CampVisits (CamperID, CampID, VisitDate)
SELECT 
    C.CamperID,
    (FLOOR(RANDOM() * 2) + 1) AS CampID,
    CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 3 * 365) AS VisitDate
FROM 
    Campers C
WHERE 
    RANDOM() < 0.3;

SELECT 
    COUNT(*) AS VisitCount
FROM 
    CampVisits CV
JOIN 
    Campers C ON CV.CamperID = C.CamperID
WHERE 
    C.FirstName = 'Lakshmi'
    AND CV.VisitDate >= CURRENT_DATE - INTERVAL '3 years';