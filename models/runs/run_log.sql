{{ config(materialized='view',
          schema='runs') }}

select *
from {{ source('raw', 'DE_Scheduler_Run_Log') }}