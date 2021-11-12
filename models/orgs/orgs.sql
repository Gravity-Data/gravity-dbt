{{ config(materialized='view') }}

select
    _id,
    dateCreated,
    location,
    nullGroupingName,
    isDisabled,
    startDayOfWeek,
    accountStripeDetails,
    usingExternalIdp,
    useFiscalYear,
    ignorePerformanceLogging,
    name,
    showWeekEndDate,
    dateFormat,
    isPasswordPolicyApplied,
    useStartDayOfWeek,
    embeddingEnabled,
    sunWeek,
    version,
    id,
    stripeCustomerId,
    gravity_id,
    gravity_inserted,
    gravity_updated
from {{ source('raw', 'Orgs') }}