{{ config(materialized='view') }}

select *
from {{ source('raw', 'DE_Scheduler_Run_Log') }}