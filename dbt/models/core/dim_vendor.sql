with vendors as (
    select 1 as vendor_id, 'Creative Mobile Technologies' as vendor_name union all
    select 2 as vendor_id, 'VeriFone Inc.' as vendor_name
)

select * from vendors
