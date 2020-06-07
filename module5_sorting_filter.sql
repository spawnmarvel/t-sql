-- Module 5: Sorting and Filtering Data

--Lesson 1:	Sorting Data
--Lesson 2:	Filtering Data with Predicates
--Lesson 3:	Filtering Data with TOP and OFFSET-FETCH
--Lesson 4:	Working with Unknown Values
--Lab:	Sorting and Filtering Data

-- ...you should add an ORDER BY clause to your SELECT statement

-- ORDER BY sorts rows in result fro presentation purpose
-- ORDER BY can refer to:
-- columns by name, alias or ordinal position (not recommended), columns not part of select list
-- Sort order ASC, DESC


-- Filtering Data in the WHERE Clause with Predicates
-- WHERE clause use predicate, must be expressed as logical conditions, only TRUE are accepted
-- Values of FALSE or UNKOWN filtered out
-- WHERE clause follows FROM, can 't see aliases declared in SELECT
-- Can be optimized by SQL server to use indexes
-- Data filtered server-side
-- Can reduce network traffic and client memory usage



