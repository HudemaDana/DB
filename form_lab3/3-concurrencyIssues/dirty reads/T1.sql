USE PoliceStation
GO

-- part 1
BEGIN TRAN
UPDATE Investigations
SET descr = 'changed in nevinovat'
WHERE Iid = 1
WAITFOR DELAY '00:00:06'
ROLLBACK TRAN