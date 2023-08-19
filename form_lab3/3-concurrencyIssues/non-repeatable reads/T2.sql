USE PoliceStation
GO

--part 2: the row is changed while T2 is in progress, so we will se both values for address
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
-- see first insert
SELECT *
FROM Investigations
WAITFOR DELAY '00:00:06'
SELECT *
FROM Investigations
COMMIT TRAN

-- DELETE FROM Investigations WHERE Iid = 2