# This is a code snippet to demo the use of the ServiceNow powershell library for accessing
# the UCSF ServiceNow platform and extracting attestation records

# Enforce TLS1.2 or everything dies
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


# Import modules - see https://github.com/Snow-Shell/servicenow-powershell, forked to https://github.com/ucsf-research-tech/servicenow-powershell
Import-Module \ServiceNow\ServiceNow.psm1 # Verify this path for import

# Auth against V2 of SN api (note use of Set-ServiceNowAuth, which replaces )
Set-ServiceNowAuth -url ucsf.service-now.com -Credentials (Get-Credential)

# Demo extraction of INCs (note that the framework defaults to limit exports from the API to 10 records - use -limit to expand this)
Get-ServiceNowIncident -MatchContains @{short_description='REDCap'}

# Tables which we care about for the attestation process:
# u_docusign_attestation_record - attestations
# u_docusign_attest_task_relatio - attestation-to-TASK 1:M relationships
# sc_task - TASK tables

# For future query-building, examine a sample query to the front-end
#
# Ex: https://ucsf.service-now.com/nav_to.do?uri=%2Fu_docusign_attestation_record_list.do%3Fsysparm_view%3D%26sysparm_first_row%3D1%26sysparm_query%3Du_statusINExpired,Voided,Declined,Failed%26sysparm_clear_stack%3Dtrue
#
# Extract table name from the start of the query after the URI, up to but not including _list.do (in this example, u_docusign_attestation_record is the table)
# Extract the sysparm encoded query from the sysparm_query field in the address (in this example, u_emailISNOTEMPTY)
#
# Then extract from that table using Get-ServiceNowTable:

$expired_attestations=Get-ServiceNowTable -Table u_docusign_attestation_record -Query "u_statusINExpired,Voided,Declined,Failed" -Limit 20 

# Note the increased -Limit
# IMPORTANT: In production, this limit needs to be expanded substantially (total number of expired attestations as of April 2021 is ~12500)

# Demonstrate output
foreach ($attestation in $expired_attestations) {write-output "$($attestation.u_number)  $($attestation.u_email)  $($attestation.u_employee_id)"}