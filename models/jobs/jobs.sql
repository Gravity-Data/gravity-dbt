{{ config(materialized='view') }}

select distinct
    {{ dbt_utils.surrogate_key(['RS.jobname', 'RS.sourcename','RS.organisationid', 'RS.resourceid']) }} as job_id,
    {{ dbt_utils.surrogate_key(['RS.jobname', 'RS.sourcename','RS.organisationid']) }} as source_id,
    {{ dbt_utils.surrogate_key(['TGT_DB_CONNECTION_NAME.value', 'TGT_DATASOURCE.value','RS.organisationid']) }} as target_id,
    RS.jobname, 
    RS.sourcename,
    RS.resourceid, 
    RS.organisationid, 
    case    when (DT.release_status is null or DS.release_status is null  or  DT.release_status ='draft'  or DS.release_status ='draft') 
                and SIA.value is not null   then 'incomplete' 
            when SIA.value is null then 'paused' 
            else RS.value   end as release_status,  
    SIA.value as schedule,
    NET.value as next_execution_time_utc, 
    datetime_diff(safe_cast(NET.value as timestamp), current_timestamp(), hour) time_to_next_execution_hours,
    DT.release_status as datatarget_release_status, 
    DS.release_status as datasource_release_status,
    TGT_DATASOURCE.value as targetname,
    TGT_DB_CONNECTION_NAME.value as connectionname 
from 
{{ref('release_status')}} RS 
left join 
{{ref('schedule_interval_anchor')}} SIA 
    on RS.jobname=SIA.jobname and  RS.sourcename=SIA.sourcename  
    and  RS.resourceid=SIA.resourceid 
    and  RS.organisationid=SIA.organisationid   
left join 
{{ref('next_execution_time')}} NET 
    on RS.jobname=NET.jobname 
    and  RS.sourcename=NET.sourcename  
    and  RS.resourceid=NET.resourceid 
    and  RS.organisationid=NET.organisationid   
left join 
{{ref('tgt_datasource')}} TGT_DATASOURCE 
    on RS.jobname=TGT_DATASOURCE.jobname 
    and  RS.sourcename=TGT_DATASOURCE.sourcename  
    and  RS.resourceid=TGT_DATASOURCE.resourceid 
    and  RS.organisationid=TGT_DATASOURCE.organisationid   
left join 
{{ref('tgt_db_connection_name')}} TGT_DB_CONNECTION_NAME 
    on RS.jobname=TGT_DB_CONNECTION_NAME.jobname 
    and  RS.sourcename=TGT_DB_CONNECTION_NAME.sourcename  
    and  RS.resourceid=TGT_DB_CONNECTION_NAME.resourceid 
    and  RS.organisationid=TGT_DB_CONNECTION_NAME.organisationid   
left join  
{{ref('targets')}} DT 
    on {{ dbt_utils.surrogate_key(['TGT_DB_CONNECTION_NAME.value', 'TGT_DATASOURCE.value','RS.organisationid']) }} = DT.target_id
left join  
{{ref('sources')}} DS 
    on {{ dbt_utils.surrogate_key(['RS.jobname', 'RS.sourcename','RS.organisationid']) }} = DS.source_id
          