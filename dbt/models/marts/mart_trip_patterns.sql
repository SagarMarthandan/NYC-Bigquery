{{ config(materialized='table') }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
)

select
    -- Route mapping
    coalesce(pickup_borough, 'Unknown') as pickup_borough,
    coalesce(dropoff_borough, 'Unknown') as dropoff_borough,
    
    -- Temporal hour grouping
    extract(hour from pickup_datetime) as pickup_hour,
    
    -- Volume metrics
    count(*) as total_trips,
    sum(passenger_count) as total_passengers,
    
    -- Route insights
    round(avg(trip_distance), 2) as avg_trip_distance,
    round(avg(fare_amount), 2) as avg_fare_amount,
    round(avg(total_amount), 2) as avg_total_amount

from fact_trips
group by 1, 2, 3
