with raw_deliveries as(
    select * from {{ source('retail_erp_bronze','deliveries')}}
),

--transformation
transformed_deliveries as (
    select
        cast(tracking_number as string) as tracking_number,
        cast(sale_id as int)as sale_id,
        cast(customer_name as string)as customer_name,
        
        -- duplicated from sales module in erp simulator
        cast(sale_date as date)as sale_date,
        cast(sale_amount as decimal(18,2)) as sale_amount,

        cast(delivery_start_date as date)as delivery_start_date,
        cast(delivery_complete_date as date)as delivery_complete_date,
        lower(delivery_status) as normalized_status,
        case
            when normalized_status = 'cancelled' then 'cancelled'
            when delivery_complete_date is not null
                and normalized_status = 'complete'
            then 'complete'
            when delivery_complete_date is not null
                and normalized_status = 'incomplete'
            then 'partial_or_split_fufilment'

            when delivery_start_date is not null
                and delivery_complete_date is null
            then 'in-progress'

            when delivery_status = 'new'
            then 'new'
            else 'unknown'
        end as delivery_fulfilment_state,
        cast(ingestion_timestamp as timestamp) as updated_at,
        current_timestamp() as dbt_updated_at        
    from raw_deliveries
),


--deduplication
deduplicated_deliveries as(
    select *,
    row_number() over (partition by tracking_number order by updated_at desc) as rn
    from transformed_deliveries
)

select
    tracking_number,
    sale_id,
    customer_name,
    sale_date,
    sale_amount,
    delivery_start_date,
    delivery_complete_date,
    delivery_fulfilment_state,
    dbt_updated_at
from deduplicated_deliveries