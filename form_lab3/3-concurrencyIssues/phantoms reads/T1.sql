USE PoliceStation
GO

-- DELETE FROM Investigations WHERE Iid = 3
-- SELECT * FROM Investigations

-- part 1
BEGIN TRAN
WAITFOR DELAY '00:00:06'
INSERT INTO Investigations
    (Tid,investigation_date, descr)
VALUES(1, '3/3/2003', 'ceva_3')
COMMIT TRAN