{{ config(materialized='ephemeral') }}

select 
distinct jobname, sourcename,resourceid, organisationid,parameter,value 
from {{ source('raw', 'truedash_conf_resources') }}  
where organisationid>1000 
and parameter='TGT_DATASOURCE'