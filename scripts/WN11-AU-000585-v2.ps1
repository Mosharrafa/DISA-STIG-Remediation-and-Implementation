<#
.SYNOPSIS
    Enables command line inclusion in process creation audit events. (v2 — Revised Fix)
.NOTES
    Author          : Mosharrafa
    LinkedIn        : https://www.linkedin.com/in/moshahm/
    GitHub          : https://github.com/Mosharrafa/DISA-STIG-Remediation-and-Implementation
    Date Created    : 2026-04-26
    Last Modified   : 2026-04-26
    Version         : 2.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000585

.VERSION HISTORY
    v1.0 - Initial script applied only the registry key
           (ProcessCreationIncludeCmdLine_Enabled = 1) — FAILED Tenable scan.
           Root cause: The registry key controls WHAT gets logged (command line data),
           but does not enable process creation auditing itself.
           Without auditpol enabling the "Process Creation" subcategory,
           no Event ID 4688 events are generated — so the registry flag has nothing to attach to.

    v2.0 - Two-step fix: registry key (Step 1) + auditpol subcategory enable (Step 2).
           Both are required. PASSED Tenable scan.

.TESTED ON
    Date(s) Tested  : 2026-04-26
    Tested By       : Mosharrafa
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. : Windows PowerShell ISE

.USAGE
    Apply using PowerShell ISE as an administrator.
    Example syntax:
    PS C:\> .\WN11-AU-000585-v2.ps1
#>

# -------------------------------------------------------------------
# Step 1 — Enable command line data inclusion in process creation events
# This controls WHAT gets logged inside each Event ID 4688 entry.
# Without this, process creation events omit the command line argument.
# -------------------------------------------------------------------
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
$valueName    = "ProcessCreationIncludeCmdLine_Enabled"
$valueData    = 1

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData
Write-Host "Step 1 applied: Command line data inclusion enabled in process creation events." -ForegroundColor Cyan

# -------------------------------------------------------------------
# Step 2 — Enable Process Creation auditing via auditpol
# This controls WHETHER Event ID 4688 events are generated at all.
# The registry key alone (Step 1) has no effect without this step.
# Both must be set for the STIG to pass.
# -------------------------------------------------------------------
auditpol /set /subcategory:"Process Creation" /failure:enable

Write-Host "Step 2 applied: Process Creation failure auditing enabled via auditpol." -ForegroundColor Cyan
Write-Host ""
Write-Host "WN11-AU-000585 (v2) complete: Both registry and auditpol settings applied." -ForegroundColor Green
