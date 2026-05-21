with payment_types as (
    select 1 as payment_type_id, 'Credit Card' as payment_description union all
    select 2 as payment_type_id, 'Cash' as payment_description union all
    select 3 as payment_type_id, 'No Charge' as payment_description union all
    select 4 as payment_type_id, 'Dispute' as payment_description union all
    select 5 as payment_type_id, 'Unknown' as payment_description union all
    select 6 as payment_type_id, 'Voided Trip' as payment_description
)

select * from payment_types
