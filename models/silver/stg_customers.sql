with raw_customers as (
    select * from {{ source('retail_erp_bronze','customers')}}
),

transformed_customers as(
    select 
        cast(id as int)as id,
        cast(business_partner_id as int)as business_partner_id,
        case
            when customer_group is null
            then customer_group = 'unknown'
        end as cleaned_customer_group,
        cast(cleaned_customer_group as string)as customer_group,
        cast(updated_at as timestamp)as updated_at,
        current_timestamp() as dbt_updated_at
    from raw_customers
),

deduplicated_customers as(
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed_customers
),

final_customers as(
    select
        id,
        business_partner_id,
        customer_group,
        dbt_updated_at
    from deduplicated_customers
)

select * from final_customers