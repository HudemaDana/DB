USE PoliceStation;
GO

-- part 2; we can read uncommited data (dirty read)
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
-- see update
SELECT *
FROM Investigations
WAITFOR DELAY '00:00:06'
-- update was rolled back
SELECT *
FROM Investigations
COMMIT TRAN

-- UPDATE Investigations SET descr = 'nu mai vreau' WHERE Iid = 1