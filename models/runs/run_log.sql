{{ config(materialized='view') }}

select
      jobname,
      sourcename,
      resourceid,
      run_id,
      start_datetime,
      end_datetime,
      datetime_diff(end_datetime, start_datetime, second) duration_sec,
      status,
      error_message,
      staged_records_count,
      new_records_count,
      updated_records_count,
      organisationid
from {{ source('raw', 'DE_Scheduler_Run_Log') }}