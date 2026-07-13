GO

BULK INSERT Dim_Host
FROM 'D:\Airbnb Project\cleaned_data\listings_dim_host.csv'
WITH (
    FORMAT = 'CSV',          
    FIRSTROW = 2,            
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n'     
)

GO

BULK INSERT Dim_Neighbour
FROM 'D:\Airbnb Project\cleaned_data\listings_dim_neighbourhood.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

GO

BULK INSERT Dim_Listings
FROM 'D:\Airbnb Project\cleaned_data\listings_base_clean.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

GO

BULK INSERT Fact_Availability
FROM 'D:\Airbnb Project\cleaned_data\listings_fact_availability.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

GO

BULK INSERT Fact_Host
FROM 'D:\Airbnb Project\cleaned_data\listings_fact_host.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

GO

BULK INSERT Fact_Calendar
FROM 'D:\Airbnb Project\cleaned_data\calendar_cleaned.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

GO

BULK INSERT Fact_Reviews
FROM 'D:\Airbnb Project\cleaned_data\fact_reviews_clean.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    )

GO 

BULK INSERT Amenities_Bridge
FROM 'D:\Airbnb Project\amenities.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    )
