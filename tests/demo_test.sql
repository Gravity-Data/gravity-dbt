select distinct
    {{ dbt_utils.surrogate_key(['jobname', 'sourcename','organisationid']) }} as source_id,
    jobname, 
    sourcename, 
    organisationid,
    value as release_status
from {{ source('raw', 'truedash_conf_datasources') }}  
where organisationid=100005