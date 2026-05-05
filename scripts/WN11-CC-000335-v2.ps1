<#
.SYNOPSIS
    Disables WinRM unencrypted traffic on the CLIENT side. (v2 — Revised Fix)
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 2.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000335

.VERSION HISTORY
    v1.0 - Initial script targeted HKLM:\...\WinRM\Service — FAILED Tenable scan.
           Root cause: Same misidentification as WN11-CC-000330.
           \Service controls incoming WinRM traffic.
           \Client controls outgoing WinRM traffic — which is what this STIG validates.

    v2.0 - Corrected registry path to HKLM:\...\WinRM\Client — PASSED Tenable scan (Final).

.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE

.USAGE
    Apply using PowerShell ISE as an administrator.
    Example syntax:
    PS C:\> .\WN11-CC-000335-v2.ps1
#>

# Define the registry path and value
# IMPORTANT: Must target \WinRM\Client — not \WinRM\Service
# \Service = incoming connections | \Client = outgoing connections (STIG checks Client)
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$valueName    = "AllowUnencryptedTraffic"
$valueData    = 0

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Apply the setting
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

Write-Host "WN11-CC-000335 (v2) applied: WinRM unencrypted traffic disabled on Client side." -ForegroundColor Green
