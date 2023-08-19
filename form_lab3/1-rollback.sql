USE PoliceStation
GO

DROP TABLE IF EXISTS LogTable
CREATE TABLE LogTable
(
    Lid INT IDENTITY PRIMARY KEY,
    TypeOperation VARCHAR(50),
    TableOperation VARCHAR(50),
    ExecutionDate DATETIME
);

GO

-- use m:n relation Library - Subscriber

CREATE OR ALTER FUNCTION ufValidateString (@str VARCHAR(1000))
RETURNS INT
AS
BEGIN
    DECLARE @return INT
    SET @return = 1
    IF(@str IS NULL OR LEN(@str) < 2 OR LEN(@str) > 1000)
	BEGIN
        SET @return = 0
    END
    RETURN @return
END
GO

CREATE OR ALTER FUNCTION ufValidateInt (@int integer)
RETURNS INT
AS
BEGIN
    DECLARE @return INT
    SET @return = 1
    IF(@int < 0)
	BEGIN
        SET @return = 0
    END
    RETURN @return
END
GO

CREATE OR ALTER FUNCTION ufValidateDate (@date Date)
RETURNS INT
AS
BEGIN
    DECLARE @return INT
    SET @return = 1
    IF(@date > GETDATE())
	BEGIN
        SET @return = 0
    END
    RETURN @return
END
GO

CREATE OR ALTER FUNCTION ufValidateName (@name VARCHAR(30))
RETURNS INT
AS
BEGIN
    DECLARE @return INT
    SET @return = 1

    DECLARE @index INT
    SET @index = 1

    WHILE @index <= LEN(@name)
	BEGIN
        IF SUBSTRING(@name, @index, 1) LIKE '[0-9]'
    BEGIN
            SET @return = 0
            BREAK
        END

        SET @index = @index + 1
    END

    RETURN @return
END
GO

CREATE OR ALTER PROCEDURE uspAddInvestigations(@Tid integer,
    @i_date date,
    @descr varchar(1000))
AS
SET NOCOUNT ON
IF (dbo.ufValidateDate(@i_date) <> 1)
	BEGIN
    RAISERROR('Investigation date is invalid', 14, 1)
END
SET NOCOUNT ON
IF (dbo.ufValidateString(@descr) <> 1)
	BEGIN
    RAISERROR('Description is invalid', 14, 1)
END
INSERT INTO Investigations
VALUES
    (@Tid, @i_date, @descr)
INSERT INTO LogTable
VALUES
    ('add', 'investigation', GETDATE())
GO

CREATE OR ALTER PROCEDURE uspAddPeople(@cnp varchar(13),
    @fname varchar(30),
    @lname varchar(30),
    @address varchar(150),
    @p_number varchar(10),
    @email varchar(50))
AS
SET NOCOUNT ON
IF (dbo.ufValidateName(@fname) <> 1)
	BEGIN
    RAISERROR('First name is invalid', 14, 1)
END
SET NOCOUNT ON
IF (dbo.ufValidateName(@lname) <> 1)
	BEGIN
    RAISERROR('Last name is invalid', 14, 1)
END
INSERT INTO People
VALUES
    (@cnp, @fname, @lname, @address, @p_number, @email)
INSERT INTO LogTable
VALUES
    ('add', 'people', GETDATE())
GO


CREATE OR ALTER PROCEDURE uspAddPeopleInInvestigation(@p_id int,
    @i_id int,
    @r_id int)
AS
SET NOCOUNT ON
IF (dbo.ufValidateInt(@r_id) <> 1 or @r_id > (select max(Rid)
    from Roles))
	BEGIN
    RAISERROR('Role id is invalid', 14, 1)
END
IF EXISTS (SELECT *
FROM PeopleInInvestigation PI
where PI.Pid = @p_id AND PI.Iid = @i_id AND PI.Rid = @r_id)
	BEGIN
    RAISERROR('People in investigation already exists', 14, 1)
END
INSERT INTO PeopleInInvestigation
VALUES
    (@p_id, @i_id, @r_id)
INSERT INTO LogTable
VALUES
    ('add', 'people_in_investigation', GETDATE())
GO

CREATE OR ALTER PROCEDURE uspAddCommitScenario
AS
BEGIN TRAN
BEGIN TRY
		EXEC uspAddPeople '1232344001285', 'George','Ionela', 'Strada Plopilor 23', '0711224925', 'practicSql@gmail.mor'
		EXEC uspAddInvestigations 1, '10/11/2002', 'si i-a dat cu o lopata in cap de o inviat a 3a zi dupa scriptura'
		EXEC uspAddPeopleInInvestigation 1, 1, 2
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH
GO


CREATE OR ALTER PROCEDURE uspAddRollbackScenario
AS
BEGIN TRAN
BEGIN TRY
		EXEC uspAddPeople '1232344001285', 'Mihai','Ceva', 'Strada Somnului 99', '0709224925', 'practicSql@gmail.momor' 
		EXEC uspAddInvestigations 1, '10/11/2025', 'si i-a dat cu o lopata in cap de o inviat a 3a zi dupa scriptura' --> fail due to date validation
		EXEC uspAddPeopleInInvestigation 1, 1, 10 --> should fail due to id validation
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH
GO

EXEC uspAddRollbackScenario
EXEC uspAddCommitScenario

SELECT *
FROM LogTable

select *
from People
select *
from Investigations
select *
from PeopleInInvestigation


DELETE FROM People
DELETE FROM Investigations
DELETE FROM PeopleInInvestigation

DBCC CHECKIDENT ('[People]', RESEED, 0);
GO
DBCC CHECKIDENT ('[Investigations]', RESEED, 0);
GO