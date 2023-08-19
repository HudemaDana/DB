USE PoliceStation;
GO

--SOLUTION: set transaction isolation level to read commited
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT *
FROM Investigations
WAITFOR DELAY '00:00:06'
SELECT *
FROM Investigations
COMMIT TRAN