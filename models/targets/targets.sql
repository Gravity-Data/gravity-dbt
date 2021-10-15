{{ config(materialized='view') }}

select 
distinct 
{{ dbt_utils.surrogate_key(['connectionname', 'targetname','organisationid']) }} as target_id,
connectionname, targetname, organisationid, value as release_status
from {{ source('raw', 'truedash_conf_datatargets') }}  
where organisationid>1000 
and parameter='RELEASE_STATUS'
