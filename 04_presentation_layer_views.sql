-- Creating the final dimension property, removing the old less informative views.
DROP VIEW IF EXISTS vw_clean_listings;
DROP VIEW IF EXISTS vw_annual_availability;
GO 

-- Using the information from fact reviews to evaluate the performance of each property. 
-- Based on the calculation for the number of datys it was active (using latest and oldest review dates)
-- And comparing the latest review date to the latest date of the overall reviews.

CREATE OR ALTER VIEW vw_dim_property AS 
-- (Fix 2: Removed the opening parenthesis here)

WITH Listing_Lifespans AS (
    -- Calculate the actual historical lifespan from the Fact table
    SELECT 
        listing_id,
        MIN(date) AS first_review_date,
        MAX(date) AS last_review_date,
        DATEDIFF(day, MIN(date), MAX(date)) AS days_active,
        DATEDIFF(day, MAX(date), '2026-05-01') AS days_since_last_review
    FROM Fact_Reviews
    GROUP BY listing_id
)

-- Build the final dimension table
SELECT 
    l.id AS listing_id,
    l.host_id,
    l.neighbourhood_id,
    l.latitude,
    l.longitude,
    l.property_type,  
    l.room_type,
    l.accommodates AS guest_capacity,
    l.bedrooms,       
    l.beds,           
    l.bathrooms,      
    l.price,
    l.minimum_nights,
    l.license,             
    l.number_of_reviews,
    
    -- The Dynamic Churn Classification
    CASE 
        WHEN l.number_of_reviews = 0 THEN 'New / Unreviewed'
        WHEN ls.days_since_last_review > 730 THEN 'Dead Listing (Inactive > 2 Yrs)'
        WHEN ls.days_active > 730 AND l.number_of_reviews < 5 THEN 'Low Performer'
        ELSE 'Active & Healthy'
    END AS Property_Health_Status

FROM Dim_Listings l
LEFT JOIN Listing_Lifespans ls 
    ON l.id = ls.listing_id
WHERE l.price < 540; 
-- (Fix 3: Removed the closing parenthesis at the end)
GO

-- Creating the final dimension host 

CREATE OR ALTER VIEW vw_dim_host AS 

WITH Clean_Host_Experience AS (
    -- Extracting distinct values to prevent duplication from the Room_Type melt
    SELECT DISTINCT 
        host_id,
        hosts_time_as_user_years AS user_tenure_years,
        hosts_time_as_host_years AS hosting_tenure_years
    FROM fact_host
)

SELECT 
    h.host_id,
    h.host_name,
    h.host_location,
    h.host_is_superhost,
    h.host_identity_verified,
    e.user_tenure_years,
    e.hosting_tenure_years
FROM Dim_Host h
LEFT JOIN Clean_Host_Experience e 
    ON h.host_id = e.host_id;
GO

-- 4. Create the Estimated Bookings view for the Fact Table
CREATE OR ALTER VIEW vw_fact_reviews AS
SELECT 
    id, 
    listing_id, 
    date, 
    reviewer_id, 
    (1 / 0.7) AS estimated_booking_weight 
FROM Fact_Reviews;
GO