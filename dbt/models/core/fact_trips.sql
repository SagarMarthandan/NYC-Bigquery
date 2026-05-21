with trips as (
    select * from {{ ref('stg_nyc_taxi__trips') }}
)

select
    -- Generate a unique surrogate key for trip_id (native, deterministic, database-independent hash)
    to_hex(sha256(concat(
        coalesce(cast(vendor_id as string), ''), '-',
        coalesce(cast(pickup_datetime as string), ''), '-',
        coalesce(cast(pickup_location_id as string), '')
    ))) as trip_id,
    
    pickup_datetime,
    dropoff_datetime,
    pickup_location_id,
    dropoff_location_id,
    passenger_count,
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount,
    payment_type_code as payment_type_id,
    vendor_id
from trips
