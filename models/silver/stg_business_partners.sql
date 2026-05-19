with raw_source as (
    select * from {{ source('retail_erp_bronze','business_partners')}}
),

--transformation
transformed as (
    select
        cast(id as int ) as id,
        cast(partner_code as string) as partner_code,
        cast(`name`as string) as full_name,
        case
            when lower(partner_type) is null then "unknown"
            when lower(partner_type) in ('individual', 'personal') then 'individual'
            when lower(partner_type) in ('company','business') then 'company'
            else 'other'
        end as partner_type,
        cast(email as string) as email,
        REGEXP_LIKE(email, "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") AS is_valid_email,
        cast(phone as string) as raw_phone_number,
        regexp_replace(`raw_phone_number`, '[^0-9]', '') as cleaned_phone_digits,
        {{ to_e164('cleaned_phone_digits') }} as phone_e164,
        cast(`address` as string) as cust_address,
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
        partner_code,
        full_name,
        partner_type,
        email,
        is_valid_email,
        phone_e164 as phone,
        cust_address,
        dbt_updated_at
    from deduplicated
    where rn = 1
)

select * from final