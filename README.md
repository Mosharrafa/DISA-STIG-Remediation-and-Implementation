# 🛡️ Windows 11 STIG Hardening — Hands-On Remediation

![STIG](https://img.shields.io/badge/STIG-Windows%2011%20V2R6-blue?style=flat-square&logo=windows)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=flat-square)
![Remediated](https://img.shields.io/badge/Remediated-3%20of%2020-orange?style=flat-square&logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows%2011%20Pro-0078D4?style=flat-square&logo=windows11)
![Scan Tool](https://img.shields.io/badge/Scan%20Tool-Tenable-00B388?style=flat-square)

---

## 📌 Overview

This project documents my **hands-on, one-by-one remediation** of DISA STIG findings on a real Windows 11 Pro machine.

A **Tenable Vulnerability Management** audit was run first to identify all failed findings. I selected **20 findings** to remediate manually — writing and testing each PowerShell script individually, verifying the fix before committing.

Each STIG control is referenced against the **[STIG-A-View online viewer](https://stigaview.com/products/win11/v2r6/)** which is the tool used throughout this lab.

| Detail | Info |
|--------|------|
| **STIG Baseline** | Microsoft Windows 11 STIG V2R6 |
| **Host** | mdecorpstig (Windows 11 Pro) |
| **Scan Tool** | Tenable Vulnerability Management |
| **Pre-Scan Date** | April 26, 2026 |
| **Total Failed (Pre-Scan)** | 256 findings |
| **Targeted for Remediation** | 20 findings |
| **Post-Scan** | ⏳ In Progress |

---

## 📊 Pre-Scan vs Post-Scan Comparison

| | Pre-Scan | Post-Scan |
|---|---|---|
| **Date** | April 26, 2026 | ⏳ Pending |
| **Total Failed Findings** | 256 | TBD |
| **CAT I Failed** | Multiple | TBD |
| **CAT II Failed** | Multiple | TBD |
| **Remediations Applied** | 0 | 20 *(target)* |
| **Report** | [📄 pre-scan\_2026-04-26.pdf](scans/pre-scan_2026-04-26.pdf) | *(Added when complete)* |

> 📝 Post-scan report will be uploaded once all 20 scripts have been applied and a re-scan is completed on the same machine.

---

## ✅ Remediation Tracker

| # | STIG ID | Description | CAT | Script | Status |
|---|---------|-------------|-----|--------|--------|
| 1 | [WN11-AU-000500](scripts/WN11-AU-000500.ps1) | Application event log size must be ≥ 32768 KB | II | ✅ | Done |
| 2 | [WN11-AU-000505](scripts/WN11-AU-000505.ps1) | Security event log size must be ≥ 1024000 KB | II | ✅ | Done |
| 3 | [WN11-AU-000510](scripts/WN11-AU-000510.ps1) | System event log size must be ≥ 32768 KB | II | ✅ | Done |
| 4 | WN11-AC-000005 | Account lockout duration must be ≥ 15 minutes | II | 🔲 | Pending |
| 5 | WN11-AC-000010 | Bad logon attempts threshold must be ≤ 3 | II | 🔲 | Pending |
| 6 | WN11-AC-000015 | Lockout counter reset must be 15 minutes | II | 🔲 | Pending |
| 7 | WN11-AC-000020 | Password history must be 24 passwords remembered | II | 🔲 | Pending |
| 8 | WN11-AC-000035 | Minimum password length must be 14 characters | II | 🔲 | Pending |
| 9 | WN11-AC-000040 | Password complexity filter must be enabled | II | 🔲 | Pending |
| 10 | WN11-00-000175 | Secondary Logon service must be disabled | II | 🔲 | Pending |
| 11 | WN11-00-000135 | Host-based firewall must be installed and enabled | II | 🔲 | Pending |
| 12 | WN11-00-000126 | Block consumer Microsoft account authentication | II | 🔲 | Pending |
| 13 | WN11-00-000210 | Bluetooth must be turned off | II | 🔲 | Pending |
| 14 | WN11-00-000150 | SEHOP must be enabled | **I** | 🔲 | Pending |
| 15 | WN11-CC-000038 | WDigest Authentication must be disabled | II | 🔲 | Pending |
| 16 | WN11-SO-000205 | LAN Manager auth level must be NTLMv2 only | **I** | 🔲 | Pending |
| 17 | WN11-AU-000050 | Audit Detailed Tracking — Process Creation Success | II | 🔲 | Pending |
| 18 | WN11-AU-000585 | Audit Detailed Tracking — Process Creation Failure | II | 🔲 | Pending |
| 19 | WN11-CC-000326 | PowerShell Script Block Logging must be enabled | II | 🔲 | Pending |
| 20 | WN11-CC-000330 | WinRM Client must not use Basic authentication | **I** | 🔲 | Pending |

---

## 📁 Repository Structure

```
DISA-STIG-Remediation-and-Implementation/
│
├── 📄 README.md
│
├── 📂 scripts/
│   ├── WN11-AU-000500.ps1    ✅ Application event log size
│   ├── WN11-AU-000505.ps1    ✅ Security event log size
│   ├── WN11-AU-000510.ps1    ✅ System event log size
│   └── ...                   🔲 More added as each is completed
│
└── 📂 scans/
    ├── pre-scan_2026-04-26.pdf    ← Tenable audit (256 findings)
    └── post-scan_TBD.pdf          ← Added after all 20 are applied
```

---

## 🚀 How to Use

1. Open **PowerShell ISE** as **Administrator**
2. Navigate to the scripts folder
3. Run the desired script:

```powershell
PS C:\> .\WN11-AU-000500.ps1
```

Each script is standalone — no dependencies or external tools needed. Success is verified via registry changes and Tenable re-scan compliance results.

---

## 📚 References

- [STIG-A-View — Windows 11 V2R6 (Lab Reference)](https://stigaview.com/products/win11/v2r6/)
- [DISA STIG Library — public.cyber.mil](https://public.cyber.mil/stigs/)
- [Windows 11 STIG V2R6 — Official Download](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_MS_Windows_11_V2R6_STIG.zip)
- [Tenable Vulnerability Management](https://www.tenable.com/products/tenable-io)

---

> 🔄 *This repo is updated live — new scripts are added as each STIG finding is manually remediated and tested. Post-scan report will be uploaded once all 20 are complete.*
