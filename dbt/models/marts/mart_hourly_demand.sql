{{ config(
    materialized='table',
    tags=['mart', 'bigquery', 'ny_taxi']
) }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
),

hourly_metrics as (
    select
        extract(hour from pickup_datetime) as hour_of_day,
        format_date('%A', cast(pickup_datetime as date)) as day_of_week,
        extract(dayofweek from pickup_datetime) as day_of_week_num,
        count(trip_id) as total_trips,
        avg(fare_amount) as avg_fare
    from fact_trips
    group by 1, 2, 3
)

select
    hour_of_day,
    day_of_week,
    total_trips,
    round(avg_fare, 2) as avg_fare
from hourly_metrics
order by day_of_week_num, hour_of_day
