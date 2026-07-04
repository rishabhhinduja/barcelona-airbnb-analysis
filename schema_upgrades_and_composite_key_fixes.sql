-- 1. Sever the Foreign Key chains
ALTER TABLE Fact_Availability DROP CONSTRAINT fk_fact_availability;
ALTER TABLE Fact_Reviews DROP CONSTRAINT fk_reviews_listings;
ALTER TABLE Fact_Calendar DROP CONSTRAINT fk_calendar_listings;
GO

-- 2. Unlock, Upgrade to BIGINT, and Re-lock
ALTER TABLE Dim_Listings DROP CONSTRAINT pk_dim_listings;
GO
ALTER TABLE Dim_Listings ALTER COLUMN id BIGINT NOT NULL;
GO
ALTER TABLE Dim_Listings ADD CONSTRAINT pk_dim_listings PRIMARY KEY (id);
GO

-- ==========================================
-- 1. UPGRADE FACT_AVAILABILITY (Composite Key)
-- ==========================================
ALTER TABLE Fact_Availability DROP CONSTRAINT pk_fact_availability;
GO
ALTER TABLE Fact_Availability ALTER COLUMN id BIGINT NOT NULL;
GO
ALTER TABLE Fact_Availability ADD CONSTRAINT pk_fact_availability PRIMARY KEY (id, availability_window);
GO

-- ==========================================
-- 2. UPGRADE FACT_CALENDAR (Composite Key)
-- ==========================================
ALTER TABLE Fact_Calendar DROP CONSTRAINT pk_fact_calendar;
GO
ALTER TABLE Fact_Calendar ALTER COLUMN listing_id BIGINT NOT NULL;
GO
ALTER TABLE Fact_Calendar ADD CONSTRAINT pk_fact_calendar PRIMARY KEY (listing_id, date);
GO

-- ==========================================
-- 3. UPGRADE FACT_REVIEWS (Standard Key)
-- ==========================================
ALTER TABLE Fact_Reviews ALTER COLUMN listing_id BIGINT;
GO

-- ==========================================
-- 4. RECONNECT ALL FOREIGN KEYS TO DIM_LISTINGS
-- ==========================================
ALTER TABLE Fact_Availability 
    ADD CONSTRAINT fk_fact_availability FOREIGN KEY (id) REFERENCES Dim_Listings(id);
GO

ALTER TABLE Fact_Reviews 
    ADD CONSTRAINT fk_reviews_listings FOREIGN KEY (listing_id) REFERENCES Dim_Listings(id);
GO

ALTER TABLE Fact_Calendar 
    ADD CONSTRAINT fk_calendar_listings FOREIGN KEY (listing_id) REFERENCES Dim_Listings(id);
GO

-- 1. Drop the flawed single-column primary key
ALTER TABLE Fact_Host DROP CONSTRAINT pk_fact_host;
GO

-- 2. Ensure last_scraped is NOT NULL (required for Primary Keys)
ALTER TABLE Fact_Host ALTER COLUMN last_scraped DATE NOT NULL;
GO

-- 3. Re-establish the correct Composite Primary Key
ALTER TABLE Fact_Host ADD CONSTRAINT pk_fact_host PRIMARY KEY (host_id, last_scraped);
GO

-- 1. Drop the primary key on Fact_Reviews
ALTER TABLE Fact_Reviews DROP CONSTRAINT pk_fact_reviews;
GO

-- 2. Upgrade BOTH massive ID columns to 64-bit architecture
ALTER TABLE Fact_Reviews ALTER COLUMN id BIGINT NOT NULL;
ALTER TABLE Fact_Reviews ALTER COLUMN reviewer_id BIGINT;
GO

-- 3. Re-establish the Primary Key on id
ALTER TABLE Fact_Reviews ADD CONSTRAINT pk_fact_reviews PRIMARY KEY (id);
GO