with raw_purchase_items as(
    select *  from {{ source('retail_erp_bronze', 'purchase_items')}} 
),
transformed_purchase_items as(
    select
        cast(id as int)as id,
        cast(purchase_id as int)as purchase_id,
        cast(inventory_id as int)as inventory_id,
        cast(quantity as decimal(18,2)) as quantity,
        cast(unit_cost as decimal(18,2))as unit_cost,
        cast(line_total as decimal(18,2))as line_total,

        cast(updated_at as timestamp) as updated_at,
        current_timestamp() as dbt_updated_at
    from raw_purchase_items  
),

--deduplication
deduplicated_purchase_items as(
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed_purchase_items
),

final_purchase_items as(
    select
        id,
        purchase_id,
        inventory_id,
        quantity,
        unit_cost,
        line_total,
        dbt_updated_at
    from deduplicated_purchase_items    
)

select * from final_purchase_items