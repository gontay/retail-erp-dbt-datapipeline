with
    sales as (select * from {{ ref('stg_sales')}}),
    sale_items as (select * from {{ ref('stg_sale_items')}}),

joined as (
    select

        -- grain
        si.id as sale_item_id,
        s.id as sale_id,

        -- header attributes
        s.customer_id,
        s.sale_date,
        s.total_amount,
        s.sale_status,
        s.payment_method,

        -- line item attributes
        si.inventory_id,
        si.unit_price,
        si.quantity,
        si.line_total,
        
        -- temporal data
        si.dbt_updated_at as sale_item_updated_at,
        s.dbt_updated_at as sale_updated_at
    
    from sale_items si
    inner join sales s
        on si.sale_id = s.id
),

final as (
    select
        sale_id,
        sale_item_id,
        customer_id,
        sale_date,
        total_amount,
        sale_status,
        payment_method,
        inventory_id,
        unit_price,
        quantity,
        line_total,

        sale_item_updated_at,
        sale_updated_at
    from joined
)

select * from final