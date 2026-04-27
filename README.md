# 🛡️ DISA STIG Remediation and Implementation — Windows 11

![STIG](https://img.shields.io/badge/STIG-Windows%2011%20V2R6-blue?style=flat-square&logo=windows)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)
![Scripts](https://img.shields.io/badge/Scripts-20%2B-orange?style=flat-square&logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows%2011%20Pro-0078D4?style=flat-square&logo=windows11)
![Scan Tool](https://img.shields.io/badge/Scan%20Tool-Tenable-00B388?style=flat-square)

---

## 📌 Project Overview

This project documents my **hands-on, end-to-end STIG remediation** on a real Windows 11 Pro machine, from initial failed audit through scripted remediation to post-scan verification.

The goal was not just compliance for its own sake. The objective was to **harden a Windows 11 endpoint against real-world attack techniques** by following the DISA STIG baseline — covering the full attack kill chain:

```
Initial Access → Credential Theft → Privilege Escalation → Lateral Movement → Persistence → Detection
```

Every script targets a specific point in that chain — either **preventing** the attack or ensuring it gets **detected**.

| Detail | Info |
|--------|------|
| **STIG Baseline** | Microsoft Windows 11 STIG V2R6 |
| **Reference Tool** | [STIG-A-View](https://stigaview.com/products/win11/v2r6/) |
| **Host** | mdecorpstig (Windows 11 Pro) |
| **Scan Tool** | Tenable Vulnerability Management |
| **Pre-Scan Date** | April 26, 2026 |
| **Total Failed (Pre-Scan)** | 256 findings |

---

## 🎯 Security Strategy

The remediations are organized by **security objective** — each batch addresses a specific layer of the defense model:

| Layer | Objective | Status |
|-------|-----------|--------|
| 🪵 Logging Capacity | Preserve forensic evidence | ✅ |
| 🔐 Account Lockout | Block brute-force attacks | ✅ |
| 🔑 Password Policy | Eliminate weak credentials | ✅ |
| 🧠 Credential Protection | Prevent LSASS/credential dumping | ✅ |
| ⬆️ Privilege Control | Stop privilege escalation | ✅ |
| 👁️ SOC Visibility | Detect attacker behavior | ✅ |
| 📂 File & Registry Audit | Detect persistence mechanisms | ✅ |
| 🔎 Deep Detection | Detect advanced attacker techniques | ✅ |
| 🌐 Remote Access Hardening | Block lateral movement via WinRM | ✅ |

---

## 📊 Pre-Scan vs Post-Scan

| | Pre-Scan | Post-Scan |
|---|---|---|
| **Date** | April 26, 2026 | ⏳ Pending |
| **Total Failed Findings** | 256 | TBD |
| **Report** | [📄 pre-scan\_2026-04-26.pdf](scans/pre-scan_2026-04-26.pdf) | *(Added when complete)* |

---

## ✅ Remediation Tracker

### 🪵 Batch 1 — Logging Capacity
*Goal: Ensure logs are never overwritten — forensic evidence preserved*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000500](scripts/WN11-AU-000500.ps1) | Application event log size ≥ 32768 KB | II | ✅ | Done |
| [WN11-AU-000505](scripts/WN11-AU-000505.ps1) | Security event log size ≥ 1024000 KB | II | ✅ | Done |
| [WN11-AU-000510](scripts/WN11-AU-000510.ps1) | System event log size ≥ 32768 KB | II | ✅ | Done |

### 🔐 Batch 2 — Account Lockout
*Goal: Stop brute-force and password guessing attacks*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AC-000005](scripts/WN11-AC-000005.ps1) | Account lockout duration ≥ 15 minutes | II | ✅ | Done |
| [WN11-AC-000010](scripts/WN11-AC-000010.ps1) | Lockout threshold ≤ 3 attempts | II | ✅ | Done |
| [WN11-AC-000015](scripts/WN11-AC-000015.ps1) | Reset lockout counter after 15 minutes | II | ✅ | Done |

### 🔑 Batch 3 — Password Policy
*Goal: Eliminate weak passwords — defend against credential stuffing and cracking*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AC-000020](scripts/WN11-AC-000020.ps1) | Password history = 24 passwords | II | ✅ | Done |
| [WN11-AC-000035](scripts/WN11-AC-000035.ps1) | Minimum password length = 14 characters | II | ✅ | Done |
| [WN11-AC-000040](scripts/WN11-AC-000040.ps1) | Password complexity filter enabled | II | ✅ | Done |

### 🧠 Batch 4 — Credential Protection
*Goal: Prevent Mimikatz-style credential dumping from LSASS memory*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-CC-000038](scripts/WN11-CC-000038.ps1) | WDigest Authentication disabled | II | ✅ | Done |
| [WN11-SO-000205](scripts/WN11-SO-000205.ps1) | LAN Manager auth = NTLMv2 only | **I** | ✅ | Done |

### ⬆️ Batch 5 — Privilege Control
*Goal: Keep attackers stuck at low privilege — block UAC bypass and escalation*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-SO-000255](scripts/WN11-SO-000255.ps1) | Standard user elevation requests denied | II | ✅ | Done |

### 👁️ Batch 7 — SOC Visibility
*Goal: Full command-line and script visibility — detect fileless malware and LOLBin abuse*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000050](scripts/WN11-AU-000050.ps1) | Audit Process Creation — Success | II | ✅ | Done |
| [WN11-AU-000585](scripts/WN11-AU-000585.ps1) | Include command line in process creation events | II | ✅ | Done |
| [WN11-CC-000326](scripts/WN11-CC-000326.ps1) | PowerShell Script Block Logging enabled | II | ✅ | Done |

### 📂 Batch 8 — File & Registry Audit
*Goal: Detect persistence mechanisms — malware drops, run key modifications, file tampering*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000581](scripts/WN11-AU-000581.ps1) | File System — Failure auditing enabled | II | ✅ | Done |
| [WN11-AU-000582](scripts/WN11-AU-000582.ps1) | File System — Success auditing enabled | II | ✅ | Done |
| [WN11-AU-000586](scripts/WN11-AU-000586.ps1) | Registry — Success auditing enabled | II | ✅ | Done |
| [WN11-AU-000589](scripts/WN11-AU-000589.ps1) | Registry — Failure auditing enabled | II | ✅ | Done |

### 🔎 Batch 9 — Deep Detection
*Goal: Detect advanced attacker behavior — LSASS access, token manipulation, privilege abuse*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000583](scripts/WN11-AU-000583.ps1) | Handle Manipulation — Failure auditing | II | ✅ | Done |
| [WN11-AU-000584](scripts/WN11-AU-000584.ps1) | Handle Manipulation — Success auditing | II | ✅ | Done |
| [WN11-AU-000587](scripts/WN11-AU-000587.ps1) | Sensitive Privilege Use — Success auditing | II | ✅ | Done |
| [WN11-AU-000588](scripts/WN11-AU-000588.ps1) | Sensitive Privilege Use — Failure auditing | II | ✅ | Done |

### 🌐 Batch 10 — Remote Access Hardening
*Goal: Block lateral movement — prevent WinRM abuse and unencrypted remote execution*

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-CC-000330](scripts/WN11-CC-000330.ps1) | WinRM Basic Authentication disabled | **I** | ✅ | Done |
| [WN11-CC-000335](scripts/WN11-CC-000335.ps1) | WinRM unencrypted traffic disabled | II | ✅ | Done |

---

## 🧠 Lessons Learned

Real-world findings from testing — what didn't work and what actually fixed it.

---

### WN11-AC-000040 — Password Complexity: Registry vs secedit

**Method 1 — Direct Registry Write (❌ Failed Tenable re-scan)**
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "PasswordComplexity" -Value 1
```
The registry key was correctly set and visible in a `secedit /export` — but Tenable still flagged it as a failure. Writing directly to the LSA registry key does not commit the change through Windows Security Policy. Tenable validates at the **effective policy level**, not raw registry values.

**Method 2 — secedit Policy Apply (✅ Confirmed working)**
```powershell
secedit /export /cfg $tempFile
(Get-Content $tempFile) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" | Set-Content $tempFile
secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY
```
Exporting, modifying, and re-applying via `secedit` commits the change through the proper Windows Security Policy channel — which is what compliance scanners actually validate against.

> ⚠️ **Key Takeaway:** For password and account policy settings, always use `secedit` or Group Policy. Never write directly to the registry and expect a compliance scan to pass — the scanner checks the enforced policy, not the raw key.

---

## 🚀 How to Use

1. Open **PowerShell ISE** as **Administrator**
2. Run any individual script:

```powershell
PS C:\> .\WN11-AU-000500.ps1
```

Each script is standalone — no dependencies or external tools required. Verify results via registry, `net accounts`, `auditpol /get`, or Tenable re-scan.

---

## 📚 References

- [STIG-A-View — Windows 11 V2R6](https://stigaview.com/products/win11/v2r6/)
- [DISA STIG Library — public.cyber.mil](https://public.cyber.mil/stigs/)
- [Windows 11 STIG V2R6 — Official Download](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_MS_Windows_11_V2R6_STIG.zip)
- [Tenable Vulnerability Management](https://www.tenable.com/products/tenable-io)
