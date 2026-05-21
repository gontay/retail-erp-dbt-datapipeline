with raw_purchases as(
    select *  from {{ source('retail_erp_bronze', 'purchases')}} 
),

transformed_purchases as(
    select 
        cast(id as int) as id,
        cast(supplier_id as int) as supplier_id,
        cast(purchase_date as date) as purchase_date,
        cast(total_amount as decimal(18,2)) as total_amount,
        lower(payment_method) as normalized_payment_method,
        lower(`status`) as normalized_status,
        case
            when normalized_payment_method is null then 'unknown'
            when normalized_payment_method in ('credit', 'credit-card') then 'credit'
            when normalized_payment_method = 'cash' then 'cash'
            else 'other'
        end as payment_method,
        case
            when normalized_status = 'completed' then 'complete'
            when normalized_status in ('error','rejected')
                or normalized_status like ('%bad%') 
            then 'error'
            when normalized_status in ('open','draft','in-progress') then 'incomplete'
            else 'unknown'
        end as purchase_status,
        cast(updated_at as timestamp) as updated_at,
        current_timestamp() as dbt_updated_at        
    from raw_purchases
),

--deduplication
deduplicated_purchases as(
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed_purchases
)

select
    id,
    supplier_id,
    purchase_date,
    total_amount,
    payment_method,
    purchase_status,
    dbt_updated_at
 from deduplicated_purchases