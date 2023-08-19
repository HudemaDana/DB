USE Lab3_DBMS
GO

-- solution: set deadlock priority to high for the second transaction
-- now, T1 will be chosen as the deadlock victim, as it has a lower priority
-- default priority is normal (0)

SET DEADLOCK_PRIORITY HIGH
BEGIN TRAN
-- exclusive lock on table Subscriber
UPDATE People SET fname = 'Transaction 2' WHERE Pid = 4
WAITFOR DELAY '00:00:10'

UPDATE Investigations SET descr = 'Transaction 2' WHERE Iid = 4
COMMIT TRAN
