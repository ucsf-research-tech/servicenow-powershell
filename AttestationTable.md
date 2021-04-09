[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Import-Module C:\github\servicenow-powershell\ServiceNow\ServiceNow.psm1
Set-ServiceNowAuth -url ucsf.service-now.com -Credentials (Get-Credential)
Get-ServiceNowIncident -MatchContains @{short_description='REDCap'}

#u_docusign_attestation_record
#u_docusign_attest_task_relatio
#sc_task
#https://ucsf.service-now.com/nav_to.do?uri=%2Fu_docusign_attestation_record_list.do%3Fsysparm_view%3D%26sysparm_first_row%3D1%26sysparm_query%3Du_emailISNOTEMPTY%26sysparm_clear_stack%3Dtrue

Get-ServiceNowTable -Table u_docusign_attestation_record -Query "u_statusINExpired,Voided,Declined,Failed" -Limit 20000
foreach ($attestation in $foo) {write-output "$($attestation.u_number)  $($attestation.u_email)  $($attestation.u_employee_id)"}