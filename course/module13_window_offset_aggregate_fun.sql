-- Lesson 1: Creating Windows with OVER

-- Windows extend T-SQL's set-based approach
-- Allow you to specify an order as part of a calc, without order of inp/output.
-- Allow partitioning / framing of rows to support functions.
-- Functions may simplyfy queries that need to find run totals, moving avg or hole's in data

-- 3 parts, for example sum() function, PARTION BY row, ORDER BY, ROWS BETWEEN UNBOUNDED PRECEDING(go to the beginning of this partitions/windows), UNBOUNDED FOLLOWING (end of partitions/window), CURRENT ROW(actual data)
-- Can help to simplify complex queuries and speed up performance

-- Windowing Components
-- Result set (OVER)
-- Window partition (PARTITION BY)
-- Frame (ROWS BETWEEN), what data am I looking at and boundarys, UP previous, CR current, UF following. Can add the calc's to the detail data

-- SalesOrderID	ProductID	OrderQty
-- Window beg
-- partion by order (first start)
    -- 43659	776	1 UP, Unbound predeceding
    -- 43659	777	3 CURRENT ROW
    -- 43659	778	1 UF, Unbound following
    -- 43659	771	1
    -- 43659	772	1
-- partion by order (first end)
    -- 43661	745	1
    -- 43661	743	1
    -- 43661	747	2
    -- 43661	712	4
-- Window end

SELECT SalesOrderID
      ,ProductID
	  ,OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) as Order_Total -- Here the frame is the total partition
FROM [AdventureWorks].[Sales].[SalesOrderDetail]
ORDER BY SalesOrderID

-- SalesOrderID	ProductID	OrderQty	Order_Total
-- 43659	776	1	26
-- 43659	777	3	26
-- 43659	778	1	26
-- 43659	771	1	26
-- 43659	772	1	26
-- 43661	745	1	38
-- 43661	743	1	38
-- 43661	747	2	38
-- 43661	712	4	38

-- Using OVER
-- Defines a window (gives the power)
-- If only OVER then the all row's
-- Multiple OVER can be used
-- OVER ([ PARTITION BY column])
--         ORDER BY, running or ranking function, top 5
--         ROWS or RANGE, entier partion or beginning to current row, or moving avg

-- Partitioning Windows
-- Limits a set of row, with the same value in partitioning
-- If non, it will window over the total row set

-- SalesOrderID	ProductID	OrderQty	Order_Total
-- 43659	776	1	26
-- 43659	777	3	26
-- 43659	778	1	26
-- 43659	771	1	26
-- 43659	772	1	26
-- 43659	773	2	26
-- 43659	774	1	26
-- 43659	714	3	26
-- 43659	716	1	26
-- 43659	709	6	26
-- 43659	712	2	26
-- 43659	711	4	26
-- 43660	762	1	2

-- Total OrderQty = 26 for SalesOrderID