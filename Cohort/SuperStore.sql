CREATE DATABASE Superstore
DROP DATABASE Superstore
SELECT *
FROM [dbo].[SuperStoreSales_Whole];

WITH t0 AS (
	SELECT *
	FROM SuperStoreSales_Whole
	WHERE YEAR(CAST([Order Date] AS datetime)) = 2018
),
t1 AS (
	SELECT [Order ID], [Order Date], [Customer ID], Sales,
	       FORMAT(CAST([Order Date] AS datetime), 'yyyy-MM-01') AS [Order Month]
	FROM t0
),

t2 AS (
	SELECT [Customer ID], FORMAT(MIN(CAST([Order Date] AS datetime)), 'yyyy-MM-01') AS [Cohort Month]
	FROM t0
	GROUP BY [Customer ID]
),
t3 AS (
	SELECT t1.*, t2.[Cohort Month], DATEDIFF(month, t2.[Cohort Month], t1.[Order Month])+1 AS [Cohort Index]
	FROM t1 
	JOIN t2 
	ON t1.[Customer ID] = t2.[Customer ID]
),
t4 AS(
	SELECT [Cohort Month], [Order Month], [Cohort Index]
	, COUNT(DISTINCT [Customer ID]) AS [Count Customer]
	FROM t3
	GROUP BY [Cohort Month], [Order Month], [Cohort Index]
),
t4_2 AS(
	SELECT [Cohort Month], [Order Month], [Cohort Index]
	, SUM(CAST(Sales AS float)) AS [Total Sales]
	FROM t3
	GROUP BY [Cohort Month], [Order Month], [Cohort Index]
	),
t5 AS (
	SELECT *
	FROM (
		SELECT [Cohort Month], [Cohort Index], [Count Customer]
		FROM t4
	) p
	PIVOT (
		SUM([Count Customer])
		FOR [Cohort Index] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
		) piv
	)
-- SELECT * FROM t5
SELECT
	[Cohort Month],
	ROUND(1.0 * [1]/[1],2) AS [1],
	ROUND(1.0 * [2]/[1],2) AS [2],
	ROUND(1.0 * [3]/[1],2) AS [3],
	ROUND(1.0 * [4]/[1],2) AS [4],
	ROUND(1.0 * [5]/[1],2) AS [5],
	ROUND(1.0 * [6]/[1],2) AS [6],
	ROUND(1.0 * [7]/[1],2) AS [7],
	ROUND(1.0 * [8]/[1],2) AS [8],
	ROUND(1.0 * [9]/[1],2) AS [9],
	ROUND(1.0 * [10]/[1],2) AS [10],
	ROUND(1.0 * [11]/[1],2) AS [11],
	ROUND(1.0 * [12]/[1],2) AS [12]
FROM t5