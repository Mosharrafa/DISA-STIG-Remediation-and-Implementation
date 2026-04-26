<#
.SYNOPSIS
    This PowerShell script configures the account lockout duration to 15 minutes or greater.
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000005
.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE
.USAGE
    Apply using PowerShell ISE as an administrator. Script success will be reflected in the policy as well as in successful compliance scans.
    Example syntax:
    PS C:\> .\WN11-AC-000005.ps1
#>

# Define the setting value
$duration = 15

# Apply the setting
net accounts /lockoutduration:$duration

# Output success message
Write-Host "WN11-AC-000005 applied: Lockout duration = $duration minutes"
