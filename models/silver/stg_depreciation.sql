with raw_source as (
    select *  from {{ source('retail_erp_bronze', 'depreciation')}}
),

--transformation
transformed as (
    select
        cast (id as int) as id,
        cast (asset_id as int) as asset_id,
        cast (depreciation_date as date) as depreciation_date,
        cast (depreciation_amount as decimal(18,2)) as depreciation_amount,
        cast (updated_at as timestamp) as updated_at,

        current_timestamp() as dbt_updated_at
    from raw_source
),

--deduplication
deduplicated as (
    select *,
    row_number() over (partition by id order by updated_at desc) as rn
    from transformed
),

final as (
    select
        id,
        asset_id,
        depreciation_date,
        depreciation_amount,
        dbt_updated_at
    from deduplicated
    where rn = 1
)

select * from final