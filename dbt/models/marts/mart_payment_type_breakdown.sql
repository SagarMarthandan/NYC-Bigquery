{{ config(
    materialized='table',
    tags=['mart', 'bigquery', 'ny_taxi']
) }}

with fact_trips as (
    select * from {{ ref('fact_trips') }}
),

dim_payment_type as (
    select * from {{ ref('dim_payment_type') }}
),

payment_metrics as (
    select
        ft.payment_type_id,
        count(ft.trip_id) as total_trips,
        sum(ft.total_amount) as total_revenue,
        avg(ft.tip_amount) as avg_tip
    from fact_trips ft
    group by 1
)

select
    pt.payment_description,
    pm.total_trips,
    round(pm.total_revenue, 2) as total_revenue,
    round(pm.avg_tip, 2) as avg_tip,
    round(
        safe_divide(pm.total_revenue, sum(pm.total_revenue) over ()) * 100,
        2
    ) as revenue_share_pct
from payment_metrics pm
inner join dim_payment_type pt
    on pm.payment_type_id = pt.payment_type_id
order by total_revenue desc
