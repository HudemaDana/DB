USE PoliceStation
GO

--part 1
INSERT INTO Investigations
    (Tid,investigation_date, descr)
VALUES(1, '2/2/2002', 's-a intamplat ceva')
BEGIN TRAN
WAITFOR DELAY '00:00:04'
UPDATE Investigations
SET descr = 'nu ceea ce ma asteptam'
WHERE Iid = 2
COMMIT TRAN