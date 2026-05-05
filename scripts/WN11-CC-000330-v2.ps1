<#
.SYNOPSIS
    Disables WinRM Basic Authentication on the CLIENT side. (v2 — Revised Fix)
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 2.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000330

.VERSION HISTORY
    v1.0 - Initial script targeted HKLM:\...\WinRM\Service — FAILED Tenable scan.
           Root cause: STIG checks the CLIENT-side policy, not the Service-side.
           The \Service path controls incoming WinRM connections.
           The \Client path controls outgoing WinRM connections — which is what this STIG validates.

    v2.0 - Corrected registry path to HKLM:\...\WinRM\Client — PASSED Tenable scan (Scan 4).

.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE

.USAGE
    Apply using PowerShell ISE as an administrator.
    Example syntax:
    PS C:\> .\WN11-CC-000330-v2.ps1
#>

# Define the registry path and value
# IMPORTANT: Must target \WinRM\Client — not \WinRM\Service
# \Service = incoming connections | \Client = outgoing connections (STIG checks Client)
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$valueName    = "AllowBasic"
$valueData    = 0

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Apply the setting
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

Write-Host "WN11-CC-000330 (v2) applied: WinRM Basic Authentication disabled on Client side." -ForegroundColor Green
