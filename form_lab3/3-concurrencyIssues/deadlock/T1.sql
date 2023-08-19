USE PoliceStation
GO

-- SELECT * FROM Investigations
-- SELECT * FROM People
-- INSERT INTO Investigations(ID, Address, Nr_Of_Books) VALUES(20, 'Zalau, nr 123', 120)
-- INSERT INTO People(CNP, Name, Age, Nr_Of_Rented_Books) VALUES(20, 'Ana', 20, 5)

-- UPDATE People SET Name = 'Ana' WHERE CNP = 20
-- UPDATE Investigations SET Address = 'Zalau, nr 123' WHERE ID = 20

-- part 1
BEGIN TRAN
-- exclusive look on table Investigations
UPDATE Investigations SET descr = 'Transaction 1' WHERE Iid = 4
WAITFOR DELAY '00:00:10'

-- this transaction will be blocked, because T2 already has an exclusive lock on People
UPDATE People SET fname = 'Transaction 1' WHERE Pid = 4
COMMIT TRAN