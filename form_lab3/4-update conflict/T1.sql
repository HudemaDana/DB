USE PoliceStation
GO

INSERT INTO Investigations
VALUES('2/3/2013', 'descr investigation')
ALTER DATABASE PoliceSStation SET ALLOW_SNAPSHOT_ISOLATION ON

WAITFOR DELAY '00:00:05'
BEGIN TRAN
UPDATE Investigations SET descr = 'New Name 1' WHERE Iid = 4
WAITFOR DELAY '00:00:05'
COMMIT TRAN

-- ALTER DATABASE Lab3_DBMS SET ALLOW_SNAPSHOT_ISOLATION OFF
-- UPDATE Investigations SET descr = 'descr investigatie' WHERE Iid = 4
-- SELECT * FROM Investigations