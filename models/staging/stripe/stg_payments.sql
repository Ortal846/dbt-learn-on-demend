with payments as ( 

 select ID payment_id,
ORDERID order_id,
status,
amount
from {{ source('stripe','payment') }}

)

select * from payments