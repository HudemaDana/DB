USE PoliceStation
GO

--solution: set transaction isolation level to repeatable read
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT *
FROM Investigations
WAITFOR DELAY '00:00:06'
-- now we see the value before the update
SELECT *
FROM Investigations
COMMIT TRAN

-- DELETE FROM Investigations WHERE Iid = 2