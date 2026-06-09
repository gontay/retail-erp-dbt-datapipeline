with raw_suppliers as (
    select * from {{ source('retail_erp_bronze','suppliers')}}
),

transformed_suppliers as(
    select 
        cast(id as int)as id,
        cast(business_partner_id as int)as business_partner_id,
        case
            when supplier_category is null
            then supplier_category = 'unknown'
        end as cleaned_supplier_category,
        cast(cleaned_supplier_category as string)as supplier_category,
        cast(updated_at as timestamp)as updated_at,
        current_timestamp() as dbt_updated_at
    from raw_suppliers
),

deduplicated_suppliers as(
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed_suppliers
),

final_suppliers as(
    select
        id,
        business_partner_id,
        supplier_category,
        dbt_updated_at
    from deduplicated_suppliers
)

select * from final_suppliers