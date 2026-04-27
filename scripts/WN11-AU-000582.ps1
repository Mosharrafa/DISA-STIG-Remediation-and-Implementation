<#
.SYNOPSIS
    This PowerShell script enables File System success auditing.
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000582
.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE
.USAGE
    Apply using PowerShell ISE as an administrator. Script success will be reflected in the registry as well as in successful compliance scans.
    Example syntax:
    PS C:\> .$2.ps1
#>

# Define subcategory
$subcategory = "File System"

# Enable success auditing
auditpol /set /subcategory:"$subcategory" /success:enable

# Output success message
Write-Host "WN11-AU-000582 applied: File System success auditing enabled"
