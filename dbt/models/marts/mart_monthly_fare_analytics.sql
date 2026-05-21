{{ config(materialized='table') }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
)

select
    -- Temporal grouping
    date_trunc(pickup_date, month) as pickup_month,
    payment_type_description,

    -- Volume metrics
    count(*) as total_trips,
    sum(passenger_count) as total_passengers,

    -- Distance metrics
    round(avg(trip_distance), 2) as avg_trip_distance,

    -- Financial metrics
    round(sum(fare_amount), 2) as total_fare_revenue,
    round(avg(fare_amount), 2) as avg_fare_amount,
    round(sum(tip_amount), 2) as total_tips,
    round(avg(tip_amount), 2) as avg_tip_amount,
    round(sum(total_amount), 2) as total_gross_revenue,

    -- Analytics metrics
    round(
        safe_divide(sum(tip_amount), sum(fare_amount)) * 100, 
        2
    ) as tip_percentage_of_fare

from fact_trips
group by 1, 2
