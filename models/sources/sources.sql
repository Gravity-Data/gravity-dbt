{{ config(materialization = 'view') }}

select distinct 
    jobname, 
    sourcename, 
    organisationid,
    value as release_status
from {{ source('raw', 'truedash_conf_datasources') }}  
where organisationid>1000 and parameter='RELEASE_STATUS' 