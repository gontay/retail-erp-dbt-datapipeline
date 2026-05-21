with raw_inventory as(
    select *  from {{ source('retail_erp_bronze', 'inventory')}} 
),

--transformation
transformed_inventory as(
    select
        cast(id as int)as id,
        cast(sku as string)as sku,
        cast(product_name as string)as product_name,
        cast(category as string)as category,
        cast(unit_price as decimal(18,2))as unit_price,
        cast(unit_cost as decimal(18,2))as unit_cost,
        cast(quantity_on_hand as int)as quantity_on_hand,
        cast(is_active as boolean)as is_active,
        cast(updated_at as timestamp)as updated_at,
        current_timestamp() as dbt_updated_at
    from raw_inventory
),

--deduplication
deduplicated_inventory as(
    select *,
        row_number() over (partition by id order by updated_at desc) as rn
    from transformed_inventory
)

select * from deduplicated_inventory