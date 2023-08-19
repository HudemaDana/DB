USE PoliceStation
GO

CREATE OR ALTER PROCEDURE uspAddInvestigationRecover(@Tid integer,
	@i_date date,
	@descr varchar(1000))
AS
SET NOCOUNT ON
BEGIN TRAN
BEGIN TRY
		IF (dbo.ufValidateDate(@i_date) <> 1)
	BEGIN
	RAISERROR('Investigation date is invalid', 14, 1)
END
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddPeopleRecover(@cnp varchar(13),
	@fname varchar(30),
	@lname varchar(30),
	@address varchar(150),
	@p_number varchar(10),
	@email varchar(50))
AS
SET NOCOUNT ON
BEGIN TRAN
BEGIN TRY
		IF (dbo.ufValidateName(@fname) <> 1)
	BEGIN
	RAISERROR('First name is invalid', 14, 1)
END
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO


CREATE OR ALTER PROCEDURE uspAddPeopleInInvestigationRecover(@p_id int,
	@i_id int,
	@r_id int)
AS
SET NOCOUNT ON
BEGIN TRAN
BEGIN TRY
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
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspBadAddScenario
AS
EXEC uspAddPeopleRecover '1232344001285', 'Mihai','Ceva', 'Strada Somnului 99', '0709224925', 'practicSql@gmail.momor'
EXEC uspAddInvestigationRecover 1, '10/11/2025', 'si i-a dat cu o lopata in cap de o inviat a 3a zi dupa scriptura'
--> fail due to date validation
EXEC uspAddPeopleInInvestigationRecover 1, 1, 10 --> should fail due to id validation
	
GO

CREATE OR ALTER PROCEDURE uspGoodAddScenario
AS
EXEC uspAddPeopleRecover '1232344001285', 'George','Ionela', 'Strada Plopilor 23', '0711224925', 'practicSql@gmail.mor'
EXEC uspAddInvestigationRecover 1, '10/11/2002', 'si i-a dat cu o lopata in cap de o inviat a 3a zi dupa scriptura'
EXEC uspAddPeopleInInvestigationRecover 1, 1, 2
GO

EXEC uspBadAddScenario
SELECT *
FROM LogTable

EXEC uspGoodAddScenario
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