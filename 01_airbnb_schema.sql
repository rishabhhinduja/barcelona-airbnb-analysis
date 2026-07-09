create database Airbnb_Database

GO

CREATE TABLE Dim_Host (
host_id INT ,
host_name VARCHAR(150),
host_location VARCHAR(255),
host_is_superhost VARCHAR(10),       
host_identity_verified VARCHAR(10),
constraint pk_dim_host primary key(host_id)
)

GO

CREATE TABLE Dim_Neighbour (
neighbourhood_id INT,
neighbourhood_cleansed VARCHAR(150),
neighbourhood_group_cleansed VARCHAR(150),
CONSTRAINT pk_dim_neighbour PRIMARY KEY (neighbourhood_id)
)

GO

CREATE TABLE Dim_Listings (
id INT,
last_scraped DATE,
source VARCHAR(50),
name VARCHAR(255),
host_id INT,
latitude DECIMAL(9, 6),
longitude DECIMAL(9, 6),
property_type VARCHAR(100),
room_type VARCHAR(100),
accommodates INT,
bathrooms DECIMAL(3, 1),
bedrooms INT,
beds INT,
price DECIMAL(10, 2),
minimum_nights INT,
maximum_nights INT,
number_of_reviews INT,
first_review DATE,
last_review DATE,
review_scores_rating DECIMAL(3, 2),
review_scores_accuracy DECIMAL(3, 2),
review_scores_cleanliness DECIMAL(3, 2),
review_scores_checkin DECIMAL(3, 2),
review_scores_communication DECIMAL(3, 2),
review_scores_location DECIMAL(3, 2),
review_scores_value DECIMAL(3, 2),
license VARCHAR(255),
reviews_per_month DECIMAL(4, 2),
neighbourhood_id INT,

CONSTRAINT pk_dim_listings PRIMARY KEY (id),
CONSTRAINT fk_listings_host FOREIGN KEY (host_id) REFERENCES Dim_Host(host_id),
CONSTRAINT fk_listings_neighbour FOREIGN KEY (neighbourhood_id) REFERENCES Dim_Neighbour(neighbourhood_id)
)

GO

CREATE TABLE Fact_Availability (
id INT,
availability_window INT,
days_available INT,
CONSTRAINT pk_fact_availability PRIMARY KEY(id,availability_window),
CONSTRAINT fk_fact_availability FOREIGN KEY(id) REFERENCES Dim_Listings(id)
)

GO

CREATE TABLE Fact_Host (
host_id INT,
last_scraped DATE,
hosts_time_as_user_years DECIMAL(5, 2),
hosts_time_as_user_months DECIMAL(5, 2),
hosts_time_as_host_years DECIMAL(5, 2),
hosts_time_as_host_months DECIMAL(5, 2),
host_listings_count INT,
calculated_host_listings_count INT,
calculated_host_listings_count_entire_homes INT,
calculated_host_listings_count_private_rooms INT,
calculated_host_listings_count_shared_rooms INT,

CONSTRAINT pk_fact_host PRIMARY KEY (host_id),
CONSTRAINT fk_fact_host_dim_host FOREIGN KEY (host_id) REFERENCES Dim_Host(host_id)
)

GO

CREATE TABLE Fact_Calendar (
listing_id INT,
date DATE,
available VARCHAR(10),
minimum_nights INT,
maximum_nights INT,

CONSTRAINT pk_fact_calendar PRIMARY KEY (listing_id, date),
CONSTRAINT fk_calendar_listings FOREIGN KEY (listing_id) REFERENCES Dim_Listings(id)
)

GO

CREATE TABLE Fact_Reviews (
listing_id INT,
id INT,
date DATE,
reviewer_id INT,

CONSTRAINT pk_fact_reviews PRIMARY KEY (id),
CONSTRAINT fk_reviews_listings FOREIGN KEY (listing_id) REFERENCES Dim_Listings(id)
)

-- Forgot to add the exploded amenities bridge table! 

CREATE TABLE Amenities_Bridge (
    listing_id INT,
    amenity_name VARCHAR(255)
);