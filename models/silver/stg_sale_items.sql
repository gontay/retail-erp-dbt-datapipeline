with raw_sale_items as(
    select *  from {{ source('retail_erp_bronze', 'sale_items')}} 
),

transformed_sale_items as(
    select
        cast(id as int)as id,
        cast(sale_id as int)as sale_id,
        cast(inventory_id as int)as inventory_id,
        cast(quantity as decimal(18,2)) as quantity,
        cast(unit_price as decimal(18,2))as unit_price,
        cast(line_total as decimal(18,2))as line_total,
        cast(updated_at as timestamp) as updated_at,
        current_timestamp() as dbt_updated_at
    from raw_sale_items
),

--deduplication
deduplicated_sale_items as(
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed_sale_items
),

final_sale_items as(
    select
        id,
        sale_id,
        inventory_id,
        quantity,
        unit_price,
        line_total,
        dbt_updated_at
    from deduplicated_sale_items    
)

select * from final_sale_items