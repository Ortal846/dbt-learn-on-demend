with payments as (
    select * from {{ref('stg_payments')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),


fct_orders as (

   select
        o.order_id,
        o.customer_id,
        sum(case when p.status = 'success' then amount end) as amount  

    from orders o,payments p
    where o.order_id = p.order_id(+)
    group by o.order_id,o.customer_id

)

select * from fct_orders
