{{ config(materialized='view') }}

select
    _id,
    dateCreated,
    firstName,
    lastName,
    locale,
    passwordExpired,
    organisation as organisationid,
    accountExpired,
    acceptedInvite,
    mfaToken as uses_mfa,
    shouldReceiveWelcomeEmail,
    isEmbeddedUser,
    accountLocked,
    userService,
    ignoreEmailsFromSystem,
    enabled,
    version,
    currentLoginDate,
    dateFormat,
    expirationDate,
    inactivityMailSent,	
    invitedBy,
    lastLoginDate,
    lastPasswordChangeDate,
    passwordReminderMailDays,
    photo,
    refreshToken,
    restoreId,
    stripeCustomerId,
    timezone,
    email_verified,
    shouldReceiveFailureNotificationEmail,
    isAccountOwner,
    gravity_id,
    gravity_inserted,
    gravity_updated
from {{ source('raw', 'Users') }}