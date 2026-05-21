{{ config(
    materialized='table',
    tags=['mart', 'bigquery', 'ny_taxi']
) }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
),

monthly_metrics as (
    select
        extract(year from pickup_datetime) as trip_year,
        extract(month from pickup_datetime) as trip_month,
        count(trip_id) as total_trips,
        sum(total_amount) as total_revenue,
        avg(fare_amount) as avg_fare,
        avg(tip_amount) as avg_tip,
        avg(trip_distance) as avg_trip_distance,
        avg(passenger_count) as avg_passenger_count
    from fact_trips
    group by 1, 2
)

select
    trip_year as year,
    trip_month as month,
    total_trips,
    round(total_revenue, 2) as total_revenue,
    round(avg_fare, 2) as avg_fare,
    round(avg_tip, 2) as avg_tip,
    round(avg_trip_distance, 2) as avg_trip_distance,
    round(avg_passenger_count, 2) as avg_passenger_count
from monthly_metrics
order by year desc, month desc
