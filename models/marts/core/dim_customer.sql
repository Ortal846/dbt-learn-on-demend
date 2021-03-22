with customers as (
    select * from {{ref('stg_customers')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),

payments as (
    select * from {{ref('stg_payments')}}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct o.order_id) as number_of_orders,
        sum(case when p.status = 'success' then amount end) as total_amount

    from orders o,payments p
    where o.order_id = p.order_id(+)

    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.total_amount
    from customers

    left join customer_orders using (customer_id)

)

select * from final

{{ config (
    materialized="table"
)}}
