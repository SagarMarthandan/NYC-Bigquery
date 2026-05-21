with trips as (
    select * from {{ ref('stg_nyc_taxi__trips') }}
),
zones as (
    select * from {{ ref('dim_zones') }}
)

select
    -- Identifiers
    trips.vendor_id,
    trips.rate_code_id,
    trips.pickup_location_id,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    trips.dropoff_location_id,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,

    -- Timestamps & Partitioning fields
    trips.pickup_datetime,
    cast(trips.pickup_datetime as date) as pickup_date,
    trips.dropoff_datetime,

    -- Trip metrics
    trips.passenger_count,
    trips.trip_distance,
    trips.store_and_fwd_flag,

    -- Payment Details & custom macro resolution
    trips.payment_type_code,
    {{ get_payment_type_description('trips.payment_type_code') }} as payment_type_description,

    -- Financial Details
    trips.fare_amount,
    trips.extra_charge,
    trips.mta_tax,
    trips.tip_amount,
    trips.tolls_amount,
    trips.improvement_surcharge,
    trips.total_amount,
    trips.congestion_surcharge

from trips
left join zones as pickup_zone
    on trips.pickup_location_id = pickup_zone.location_id
left join zones as dropoff_zone
    on trips.dropoff_location_id = dropoff_zone.location_id
