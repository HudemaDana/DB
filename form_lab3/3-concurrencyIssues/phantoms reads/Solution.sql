USE PoliceStation
GO

-- solution: set transaction isolation level to serializable
SET TRAN ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT *
FROM Investigations
WAITFOR DELAY '00:00:06'
SELECT *
FROM Investigations
COMMIT TRAN