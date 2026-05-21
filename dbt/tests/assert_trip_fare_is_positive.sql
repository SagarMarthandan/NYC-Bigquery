-- Singular test: Checks that base fare amounts are positive.
-- A trip should not have a negative base fare. If it does, this test will fail by returning those rows.

select
    vendor_id,
    pickup_datetime,
    fare_amount
from {{ ref('fact_trips') }}
where fare_amount < 0
