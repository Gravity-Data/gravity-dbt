{{ config(materialized='view') }}

select 
distinct connectionname, targetname, organisationid, value as release_status
from {{ source('raw', 'truedash_conf_datatargets') }}  
where organisationid>1000 
and parameter='RELEASE_STATUS'
