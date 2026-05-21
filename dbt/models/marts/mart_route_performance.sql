{{ config(
    materialized='table',
    tags=['mart', 'bigquery', 'ny_taxi']
) }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
),

dim_location as (
    select * from {{ ref('dim_location') }}
),

route_aggregation as (
    select
        ft.pickup_location_id,
        ft.dropoff_location_id,
        count(ft.trip_id) as total_trips,
        sum(ft.total_amount) as total_revenue,
        avg(ft.fare_amount) as avg_fare,
        avg(ft.trip_distance) as avg_distance
    from fact_trips ft
    group by 1, 2
)

select
    pl.zone as pickup_zone,
    pl.borough as pickup_borough,
    dl.zone as dropoff_zone,
    dl.borough as dropoff_borough,
    ra.total_trips,
    round(ra.total_revenue, 2) as total_revenue,
    round(ra.avg_fare, 2) as avg_fare,
    round(ra.avg_distance, 2) as avg_distance
from route_aggregation ra
inner join dim_location pl
    on ra.pickup_location_id = pl.location_id
inner join dim_location dl
    on ra.dropoff_location_id = dl.location_id
order by ra.total_trips desc
