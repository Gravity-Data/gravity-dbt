{{ config(materialized='view') }}

select distinct 
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
    DT.release_status as datatarget_release_status, 
    DS.release_status as datasource_release_status  
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
    on TGT_DB_CONNECTION_NAME.value=DT.connectionname 
    and  TGT_DATASOURCE.value=DT.targetname   
    and  RS.organisationid=DT.organisationid 
left join  
{{ref('sources')}} DS 
    on RS.jobname=DS.jobname 
    and  RS.sourcename=DS.sourcename 
    and  RS.organisationid=DS.organisationid 
          