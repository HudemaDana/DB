USE Lab3_DBMS
GO

-- SELECT * FROM Investigations
-- SELECT * FROM People

-- part 1
BEGIN TRAN
-- exclusive lock on People
UPDATE People SET fname = 'Transaction 2' WHERE Pid = 4
WAITFOR DELAY '00:00:10'

-- this transaction will be blocked, because T1 already has an exclusive lock on Library
UPDATE Investigations SET descr = 'Transaction 2' WHERE Iid = 4
COMMIT TRAN

-- this transaction will be chosen as the deadlock victim
-- and it will terminate with an error
-- the tables will contain the values from T1