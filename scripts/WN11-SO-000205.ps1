<#
.SYNOPSIS
    This PowerShell script sets the LAN Manager authentication level to NTLMv2 only, refusing LM and NTLM.
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000205
.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE
.USAGE
    Apply using PowerShell ISE as an administrator. Script success will be reflected in the registry as well as in successful compliance scans.
    Example syntax:
    PS C:\> .\WN11-SO-000205.ps1
#>

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "LmCompatibilityLevel"
$valueData = 5

# Check if the registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output success message
Write-Host "WN11-SO-000205 applied: NTLMv2 only, refuse LM and NTLM"
