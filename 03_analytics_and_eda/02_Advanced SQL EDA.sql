-- Assuming of total bookings, 70% of customers left a review, so analysing total bookings of airbnb in barcelona for 16 years.
-- to prevent financially too optimistic decisions about the final revenue

select 
round(count(id)/0.7,2) as Total_Bookings
from Fact_Reviews;

-- Now, analysing how bookings increased or were effected year over year. 
with year_wise_bookings as (
select 
year(Date) as Year,
round(count(id)/0.7,0) as Total_Bookings
from Fact_Reviews
group by year(Date)
)
select *,
round((Total_Bookings- lag(Total_Bookings,1) over(order by year asc))*100/lag(Total_Bookings,1) over(order by year asc),2) as YoY_Analysis
from year_wise_bookings 
where year!=2010 and year!=2026
order by year asc 

-- Clearly the first and last years are outliers, coz may be the data was not scraped for the full years..., so we'd rather filter them out.
-- In the year 2020 the bookings dropped by 70% compared to the last year.

-- Analysing effect of different dimensions over the total bookings. 

-- 1. Neighbourhood Effect 

select 
	n.neighbourhood_group_cleansed as Neighbourhood_Group,
	round(count(r.reviewer_id)/0.7,0) as Total_Bookings,
	round(sum(l.minimum_nights * l.price)/0.7,0)as Minimum_Total_Revenue
from vw_clean_listings as l
join Dim_Neighbour as n 
on l.neighbourhood_id=n.neighbourhood_id
join Fact_Reviews as r 
on l.listing_id=r.listing_id
group by n.neighbourhood_group_cleansed
order by Minimum_Total_Revenue desc, Total_Bookings desc 

-- Exiample has the most, around total 661k bookings in the past 15-16 years, with a minimum revenue of 344 Million!

-- Host Effect 
select
	h.host_name,
	count(distinct l.listing_id) as Total_Listings,
	round(count(r.reviewer_id)/0.7,0) as Total_Bookings,
	round(sum(l.price*l.minimum_nights)/0.7,0) as Minimum_Total_Revenue
from vw_clean_listings as l 
join Fact_Reviews as r 
on l.listing_id=r.listing_id 
join Dim_Host as h 
on l.host_id=h.host_id
join vw_annual_availability as a 
on l.listing_id=a.id
where a.Host_Authenticity='okay' 
group by h.host_id,h.host_name
order by Minimum_Total_Revenue desc, Total_Bookings desc

-- Host named 'Sweett' has around 276 listings and 28k total bookings and a 13 Million minimum revenue in the past 16 years.

-- Property Effect 

select 
	l.property_type as Property_Type,
	avg(l.guest_capacity) as Accomodates,
	round(count(r.reviewer_id)/0.7,0) as Total_Bookings,
	round(sum(l.price*l.minimum_nights)/0.7,0) as Minimum_Total_Revenue
from vw_clean_listings as l
join Fact_Reviews as r 
on l.listing_id=r.listing_id
group by l.property_type
order by Minimum_Total_Revenue desc, Total_Bookings desc

-- Entire rental units have the most bookings, around 1M and a minimum revenue of 561 Million over the last 16 years.

-- The overall analysis of the top properties hosted by top hosts in the top locations.

select top 10
n.neighbourhood_group_cleansed,
h.host_name,
l.property_type,
round(count(r.reviewer_id)/0.7,0) as Total_Bookings,
round(sum(l.price*l.minimum_nights)/0.7,0) as Min_Total_Revenue
from vw_clean_listings as l
join Dim_Neighbour as n 
on l.neighbourhood_id=n.neighbourhood_id
join dim_host as h 
on l.host_id=h.host_id 
join Fact_Reviews as r 
on l.listing_id=r.listing_id
group by n.neighbourhood_group_cleansed,h.host_id,h.host_name,l.property_type
order by Min_Total_Revenue desc, Total_Bookings desc

-- Of 10, 6 listings are dominated by Entire rental units in Exiample, with the top host being sweett with 22k bookings and 11 M total revenue.
