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
        
),