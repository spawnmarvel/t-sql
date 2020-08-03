-- Lesson 1: Implementing T-SQL Error Handling
-- Raise error using with RAISEERROR
-- Raise error with THROW
-- @@ERROR sty var
-- Make custom err and create alerts when error is detected

-- Errors and Error Messages
-- Number, identify error
-- Message, describing error
-- Severity, from 1-25
-- State, internal code for state / database engine
-- Procedure, name of proc/trigger where the error was detected
-- Line num, what line generated error

-- Errors from system, is in sys.messages
-- To add application error (custom) use sp_add_message

-- @msgnum, @severity, @msgtext, @lang,
EXEC sp_addmessage 50001, 10, N'NA value entered'



SELECT * FROM sys.messages 
WHERE language_id= 1033
-- message_id, language_id, severity, is_event_logged, text
-- 50001	1033	10	0	NA value entered
-- 21	1033	20	0	Warning: Fatal error %d occurred at %S_DATE. Note the error and time, and contact your system administrator.
-- 101	1033	15	0	Query not allowed in Waitfor.
-- 102	1033	15	0	Incorrect syntax near '%.*ls'.
-- 103	1033	15	0	The %S_MSG that starts with '%.*ls' is too long. Maximum length is %d.
-- 104	1033	15	0	ORDER BY items must appear in the select list if the statement contains a UNION, INTERSECT or EXCEPT operator.
-- 105	1033	15	0	Unclosed quotation mark after the character string '%.*ls'.
-- 106	1033	16	0	Too many table names in the query. The maximum allowable is %d.
-- 107	1033	15	0	The column prefix '%.*ls' does not match with a table name or alias name used in the query.
-- 108	1033	15	0	The ORDER BY position number %ld is out of range of the number of items in the select list.
-- 109	1033	15	0	There are more columns in the INSERT statement than values specified in the VALUES clause. The number of values in the VALUES clause must match the number of columns specified in the INSERT statement.
-- 110	1033	15	0	There are fewer columns in the INSERT statement than values specified in the VALUES clause. The number of values in the VALUES clause must match the number of columns specified in the INSERT statement.
-- 111	1033	15	0	'%ls' must be the first statement in a query batch.
-- 112	1033	15	0	Variables are not allowed in the %ls statement.
-- 113	1033	15	0	Missing end comment mark '*/'.

EXEC sp_dropmessage 50001

-- Raising Errors Using RAISERROR
-- For troubleshoot, check values, return text
-- PRINT(same as RAISERROR with sev 10) and RAISERROR
-- msg text, severity, state
RAISERROR('Error raised',1, 1);
-- Error raised
-- Msg 50000, Level 1, State 1

-- Raising Errors Using THROW
-- Simpler method for raising, but must have minimum num 50000
-- Is always sev 16
--
EXEC sp_addmessage 50001, 10, N'NA value entered';
THROW 50001, 'Error occured', 0;
-- Msg 50001, Level 16, State 0, Line 1
-- Error occured

-- Using @@Error
-- @@error returns last error code, is a system var
-- can be stored in @var
RAISERROR('msg text', 16,1);
IF @@ERROR <> 0
	PRINT 'error num: ' + CAST(@@ERROR AS VARCHAR(20));
GO
-- Msg 50000, Level 16, State 1, Line 1
-- msg text
-- error num: 0

-- Creating Alerts When Errors Occur
-- Alerts can trigger by msg that is stored in win log
-- If not usually logged, use WITH LOG when it is raised

-- IF ERROR IN SQL SERVER
-- Error is written to win event log
-- Alert via SQL Agent is created that monitor win event log
-- When that occurs in the win event log
-- Then SQL ser can trigger the alert (send email, exec proc or more)
-- Check if event is logged
SELECT is_event_logged FROM sys.messages 
WHERE language_id= 1033

--DEMO
USE test;
GO
-- Raise custom 
RAISERROR ('No action needed',10,1) -- level 10 is a warning
-- No action needed

RAISERROR ('No action needed',14,1) -- Change level to 14 = error
-- Msg 50000, Level 16, State 1, Line 3
-- No action needed

-- Raise custom 
RAISERROR (N'%s %d %s',10,1,N'Error numb:',123,N'- All ok')
-- Error numb: 123 - All ok

--Catch @@error num
DECLARE @error_num INT;
RAISERROR('Capture number for error', 14,1);
SET @error_num = @@ERROR
IF @error_num <> 0 --no error
	PRINT 'Error msg ' + CAST(@error_num as VARCHAR(20))
-- Msg 50000, Level 14, State 1, Line 2
-- Capture number for error
-- Error msg 50000

-- Create user defined error
EXEC sp_addmessage 50005, 10,N'User defined error'
-- Call it
RAISERROR(50005, 10, 1)
-- result
-- User defined error

