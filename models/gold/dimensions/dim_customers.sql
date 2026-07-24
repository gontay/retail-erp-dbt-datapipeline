with business_partners as (select * from {{ ref('stg_business_partners') }}),
     customers as (select * from {{ ref('stg_customers') }}),

joined as (
    select
        c.id as customer_id,
        c.business_partner_id,

        bp.full_name as customer_name,
        bp.email,
        bp.phone,
        bp.bp_address,

        c.customer_group,
        bp.partner_type,
        c.dbt_updated_at as customer_updated_at,
        bp.dbt_updated_at as business_partner_updated_at
    
    from customers c
    left join business_partners bp
        on c.business_partner_id = bp.id
),

final as (
    select
        customer_id,
        business_partner_id,
        customer_name,
        email,
        phone,
        bp_address,
        customer_group,
        partner_type,

        -- lineage fields (optional but useful)
        customer_updated_at

    from joined
)

select * from final