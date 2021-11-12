{{ config(materialized='view') }}

select
    _id,
    userId,
    loginDate,
    gravity_id,
    gravity_inserted
from {{ source('raw', 'UsersLoginHistory') }}