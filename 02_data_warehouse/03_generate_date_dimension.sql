/* ==============================================================================
SCRIPT: Generate Date Dimension (Dim_Date)
PURPOSE: 
Creates a centralized master calendar table to enable consistent Time 
Intelligence (YTD, MoM, rolling averages) across all downstream BI tools.
==============================================================================
*/

-- 1. Create the Dim_Date Table
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD for fast indexing
    full_date DATE NOT NULL,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(15),
    day_of_month INT,
    day_of_week INT,
    day_name VARCHAR(15),
    is_weekend BIT
);
GO

-- 2. Populate it dynamically using a WHILE loop
DECLARE @StartDate DATE = '2010-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (
        date_key, full_date, year, quarter, month, month_name, 
        day_of_month, day_of_week, day_name, is_weekend
    )
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
        @StartDate,
        DATEPART(YEAR, @StartDate),
        DATEPART(QUARTER, @StartDate),
        DATEPART(MONTH, @StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(DAY, @StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END -- 1 = Sunday, 7 = Saturday
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO
