with raw_source as (
    select *  from {{ source('retail_erp_bronze', 'assets')}}
),

--transformation
transformed as (
    select
        cast(id as int) as id,
        cast(asset_code as string) as asset_code,
    
        cast(category as string) as category,
        cast(acquisition_date as date) as acquisition_date,
        cast(acquisition_cost as decimal(18,2))as acquisition_cost,
        cast(useful_life_months as int)as useful_life_months,
        cast(salvage_value as decimal(18,2))as salvage_value,
    
        case
            when lower(status) is null then 'unknown'
            when lower(status) in ('active', 'in_use', 'operational') then 'active'
            when lower(status) = 'retired' then 'retired'
            when lower(status) like '%maintenance%' then 'under_maintenance'
            else 'other'
        end as asset_status,
        cast(updated_at as timestamp) as updated_at,
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
        asset_code,
        asset_name,
        category,
        acquisition_date,
        acquisition_cost,
        useful_life_months,
        salvage_value,
        status,
        dbt_updated_at,
     from deduplicated
    where rn = 1
)

select * from final

