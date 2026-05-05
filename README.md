# 🛡️ DISA STIG Remediation and Implementation — Windows 11

![STIG](https://img.shields.io/badge/STIG-Windows%2011%20V2R6-blue?style=flat-square&logo=windows)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=flat-square)
![Scripts](https://img.shields.io/badge/Scripts-20%2B-orange?style=flat-square&logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows%2011%20Pro-0078D4?style=flat-square&logo=windows11)
![Scan Tool](https://img.shields.io/badge/Scan%20Tool-Tenable-00B388?style=flat-square)

---

## 📌 Project Overview

This project documents my **hands-on, end-to-end STIG remediation** on a real Windows 11 Pro machine — from an initial failed audit through iterative scripted remediation to post-scan verification across **6 Tenable scans**.

The goal was not just compliance for its own sake. The objective was to **harden a Windows 11 endpoint against real-world attack techniques** by following the DISA STIG baseline — covering the full attack kill chain:

```
Initial Access → Credential Theft → Privilege Escalation → Lateral Movement → Persistence → Detection
```

Every script targets a specific point in that chain — either **preventing** the attack or ensuring it gets **detected**.

> ⚠️ **This is a live project.** Remediation is ongoing. Some STIGs required multiple attempts before passing — those failures and fixes are documented in the [Lessons Learned](#-lessons-learned) section. That's the point: real-world hardening is iterative, not perfect on the first try.

| Detail | Info |
|--------|------|
| **STIG Baseline** | Microsoft Windows 11 STIG V2R6 |
| **Reference Tool** | [STIG-A-View](https://stigaview.com/products/win11/v2r6/) |
| **Host** | mdecorpstig (Windows 11 Pro Build 26200) |
| **Scan Tool** | Tenable Vulnerability Management |
| **First Scan** | April 25, 2026 |
| **Latest Scan** | May 2, 2026 |
| **Total Scans Run** | 6 |

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

## 📊 Scan History & Remediation Progress

Six Tenable scans were run across 8 days of active remediation. Each scan validated the effect of the latest batch of scripts.

| Scan | Date & Time | Failed | Passed | Pass Rate | Notes |
|------|-------------|--------|--------|-----------|-------|
| **Scan 1** | Apr 25, 2026 — 20:41 | 153 | 95 | 38.3% | Baseline — first scan |
| **Scan 2** | Apr 25, 2026 — 23:38 | 150 | 101 | 40.2% | Batch 1–3 applied |
| **Scan 3** | Apr 26, 2026 — 13:11 | 148 | 103 | 41.0% | Batch 4–5 applied |
| **Scan 4** | Apr 26, 2026 — 14:28 | 143 | 108 | 43.0% | WinRM fix applied (CC-000330 passes) |
| **Scan 5** | Apr 27, 2026 — 13:23 | 124 | 127 | 50.6% | Batch 7–9 applied; majority fixed |
| **Final** | May 02, 2026 — 01:03 | 122 | 129 | **51.4%** | Batch 10 + additional fixes |

> **Note on the final scan:** The final scan uses a refreshed Tenable policy template, which introduced some previously untested STIGs into scope. Some STIGs that passed in earlier scans show as failed in the final scan due to policy scope changes — not regression. This is expected behavior in real compliance programs when scan templates are updated.

---

## ✅ Remediation Tracker

Each section below represents a distinct security objective. The goal here is not just to list what was done — but to explain **why it matters**, **what attack it prevents or detects**, and **how the specific controls achieve that**. Compliance without understanding is just checkbox-ticking.

---

### 🪵 Logging Capacity

**Why this matters:** Logs are the only source of truth during an incident. If an attacker can exhaust your log storage, Windows starts overwriting old events — and your forensic trail disappears. An attacker who moves slowly and quietly can stay completely invisible if logs are not sized correctly. This is one of the first things a skilled attacker will count on.

**What these controls do:** The Windows Event Log has three critical channels — Application, Security, and System. By default, their maximum sizes are far too small for any real environment. The STIG mandates minimum sizes that ensure enough history is retained to reconstruct an attack timeline even if detection is delayed by days.

**Attack chain relevance:** `Persistence → Detection` — Without adequate log retention, a SOC analyst or IR team has no evidence to work with after the fact.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000500](scripts/WN11-AU-000500.ps1) | Application event log size ≥ 32768 KB | II | ✅ | Done |
| [WN11-AU-000505](scripts/WN11-AU-000505.ps1) | Security event log size ≥ 1024000 KB | II | ✅ | Done |
| [WN11-AU-000510](scripts/WN11-AU-000510.ps1) | System event log size ≥ 32768 KB | II | ✅ | Done |

---

### 🔐 Account Lockout

**Why this matters:** Password spraying and brute-force attacks are among the most common initial access techniques in the wild. Without a lockout policy, an attacker can attempt thousands of passwords against a local account with zero friction. A single weak password — or a reused one from a breach dump — is all it takes.

**What these controls do:** Account lockout policy enforces three things together: how many failed attempts trigger a lockout, how long the account stays locked, and how long before the failed-attempt counter resets. All three must be configured correctly — a lockout threshold without a proper reset window is easily bypassed by spacing out login attempts.

**Attack chain relevance:** `Initial Access` — Stops automated credential attacks before they gain a foothold.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AC-000005](scripts/WN11-AC-000005.ps1) | Account lockout duration ≥ 15 minutes | II | ✅ | Done |
| [WN11-AC-000010](scripts/WN11-AC-000010.ps1) | Lockout threshold ≤ 3 attempts | II | ✅ | Done |
| [WN11-AC-000015](scripts/WN11-AC-000015.ps1) | Reset lockout counter after 15 minutes | II | ✅ | Done |

---

### 🔑 Password Policy

**Why this matters:** Weak passwords are the single most exploited vulnerability in enterprise environments — not because of zero-days, but because humans pick predictable credentials. Credential stuffing attacks use breach databases containing billions of real passwords. Short, simple, or reused passwords fall instantly. A 14-character complex password with history enforcement is exponentially harder to crack or reuse.

**What these controls do:** Password complexity enforces that passwords must contain a mix of character types (uppercase, lowercase, numbers, symbols). Minimum length sets the floor at 14 characters. Password history prevents users from cycling back to the same password after a forced change — which is the most common way users defeat reset policies.

**Attack chain relevance:** `Initial Access → Credential Theft` — Raises the cost of offline cracking attacks and prevents credential reuse across incidents.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AC-000020](scripts/WN11-AC-000020.ps1) | Password history = 24 passwords | II | ✅ | Done |
| [WN11-AC-000035](scripts/WN11-AC-000035.ps1) | Minimum password length = 14 characters | II | ✅ | Done |
| [WN11-AC-000040](scripts/WN11-AC-000040.ps1) | Password complexity filter enabled | II | ✅ | Done |

---

### 🧠 Credential Protection

**Why this matters:** Once an attacker has code execution on a machine, their next goal is almost always credential dumping. Tools like Mimikatz target LSASS memory to extract plaintext passwords and NTLM hashes — which can then be used to move laterally across the network without ever cracking a password. This is one of the most impactful post-exploitation techniques in real-world attacks and ransomware campaigns.

**What these controls do:** WDigest authentication was designed for older HTTP digest authentication and stores credentials in plaintext in LSASS memory. Disabling it means Mimikatz cannot pull plaintext passwords from memory. The LAN Manager authentication setting forces NTLMv2-only — older LM and NTLMv1 hashes are weak and can be cracked almost instantly with modern hardware.

**Attack chain relevance:** `Credential Theft → Lateral Movement` — Removes the plaintext credentials that attackers rely on for pass-the-hash and lateral movement.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-CC-000038](scripts/WN11-CC-000038.ps1) | WDigest Authentication disabled | II | ✅ | Done |
| [WN11-SO-000205](scripts/WN11-SO-000205.ps1) | LAN Manager auth = NTLMv2 only | **I** | ✅ | Done |

---

### ⬆️ Privilege Control

**Why this matters:** Most malware and attacker tools initially land in a low-privilege user context. The next step is always privilege escalation — getting to Administrator or SYSTEM so they can install persistence, disable defenses, or dump credentials. UAC (User Account Control) is a key gate. If standard users can silently approve elevation prompts, that gate doesn't exist.

**What these controls do:** This setting configures UAC to automatically deny elevation requests from standard users rather than prompting for credentials. Without this, a standard user process could trigger a UAC prompt that a local admin might unknowingly approve — or that malware could use to social engineer its way to elevated privileges.

**Attack chain relevance:** `Privilege Escalation` — Keeps attackers trapped at standard user privilege even after gaining initial code execution.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-SO-000255](scripts/WN11-SO-000255.ps1) | Standard user elevation requests denied | II | ✅ | Done |

---

### 👁️ SOC Visibility

**Why this matters:** Modern attackers rarely use custom malware. Instead, they abuse tools that are already on the system — PowerShell, WMI, cmd.exe, certutil, mshta. This technique is called Living off the Land (LOLBins). Without process creation auditing and command-line logging, a SOC analyst sees that `powershell.exe` ran — but not what command it executed. Script block logging captures the full PowerShell payload, even if it was obfuscated or downloaded at runtime.

**What these controls do:** Process Creation auditing (Event ID 4688) records every new process spawned on the system. The command-line extension adds the full command used to launch that process — turning a vague "PowerShell ran" into "PowerShell ran this encoded download cradle." Script Block Logging (Event ID 4104) captures the actual PowerShell code that executed, even after deobfuscation.

**Attack chain relevance:** `Detection` — Provides the visibility needed to detect fileless attacks, LOLBin abuse, and malicious scripts that never touch disk.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000050](scripts/WN11-AU-000050.ps1) | Audit Process Creation — Success | II | ✅ | Done |
| [WN11-AU-000585](scripts/WN11-AU-000585.ps1) | Include command line in process creation events | II | ✅ | Done |
| [WN11-CC-000326](scripts/WN11-CC-000326.ps1) | PowerShell Script Block Logging enabled | II | ✅ | Done |

---

### 📂 File & Registry Audit

**Why this matters:** Persistence is what keeps attackers in your environment after a reboot. The most common persistence mechanisms involve writing to specific registry keys (Run keys, services, scheduled tasks) or dropping files into specific locations. Without auditing these operations, malware can establish persistence and never generate a single suspicious log entry.

**What these controls do:** File system auditing records both successful and failed access to files and directories (Event IDs 4663, 4656). Registry auditing records reads and writes to registry keys (Event ID 4657). Together, these two audit categories form a detection layer specifically against the most common persistence techniques — if malware writes to a Run key, that write is now logged.

**Attack chain relevance:** `Persistence → Detection` — Creates an audit trail around the exact locations attackers use to survive reboots and maintain access.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000581](scripts/WN11-AU-000581.ps1) | File System — Failure auditing enabled | II | ✅ | Done |
| [WN11-AU-000582](scripts/WN11-AU-000582.ps1) | File System — Success auditing enabled | II | ✅ | Done |
| [WN11-AU-000586](scripts/WN11-AU-000586.ps1) | Registry — Success auditing enabled | II | ✅ | Done |
| [WN11-AU-000589](scripts/WN11-AU-000589.ps1) | Registry — Failure auditing enabled | II | ✅ | Done |

---

### 🔎 Deep Detection

**Why this matters:** The most dangerous attacker techniques — LSASS memory access, token impersonation, SeDebugPrivilege abuse — are designed to be invisible. They abuse legitimate Windows mechanisms rather than dropping malware. Detecting these requires auditing at a lower level than most environments bother to configure. Handle manipulation auditing specifically catches the moment an attacker's process opens a handle to LSASS, which is the prerequisite to every memory-based credential dump.

**What these controls do:** Handle Manipulation auditing (Event ID 4658/4690) records when object handles are opened, duplicated, or closed — including handles to sensitive processes like LSASS. Sensitive Privilege Use auditing (Event ID 4673/4674) records when a process exercises a high-risk privilege such as `SeDebugPrivilege` (required for Mimikatz), `SeTcbPrivilege`, or `SeImpersonatePrivilege`. Together these two categories surface the behavioral fingerprint of credential dumping and token manipulation attacks.

**Attack chain relevance:** `Credential Theft → Privilege Escalation → Detection` — Provides forensic visibility into the exact moment an attacker attempts to dump credentials or impersonate a privileged account.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-AU-000583](scripts/WN11-AU-000583.ps1) | Handle Manipulation — Failure auditing | II | ✅ | Done |
| [WN11-AU-000584](scripts/WN11-AU-000584.ps1) | Handle Manipulation — Success auditing | II | ✅ | Done |
| [WN11-AU-000587](scripts/WN11-AU-000587.ps1) | Sensitive Privilege Use — Success auditing | II | ✅ | Done |
| [WN11-AU-000588](scripts/WN11-AU-000588.ps1) | Sensitive Privilege Use — Failure auditing | II | ✅ | Done |

---

### 🌐 Remote Access Hardening

**Why this matters:** WinRM (Windows Remote Management) is the protocol behind PowerShell remoting — a legitimate admin tool that attackers love to abuse for lateral movement. If WinRM allows Basic Authentication, credentials are sent in a format that is trivially decoded from network captures. If unencrypted traffic is allowed, the entire session content — commands, outputs, credentials — travels in cleartext across the wire.

**What these controls do:** Disabling Basic Authentication on the WinRM Client forces the use of stronger authentication mechanisms (Kerberos, NTLM with encryption). Disabling unencrypted traffic ensures that all WinRM sessions are encrypted in transit, even on internal networks. Both settings target the **Client** side policy — meaning they govern how this machine initiates outbound remote connections, which is what the STIG specifically checks.

**Attack chain relevance:** `Lateral Movement` — Removes the two most common methods attackers use to abuse WinRM for credential harvesting and remote command execution during network-wide compromise.

| STIG ID | Description | CAT | Script | Status |
|---------|-------------|-----|--------|--------|
| [WN11-CC-000330](scripts/WN11-CC-000330.ps1) | WinRM Basic Authentication disabled | **I** | ✅ | Done |
| [WN11-CC-000335](scripts/WN11-CC-000335.ps1) | WinRM unencrypted traffic disabled | II | ✅ | Done |

---

## 🧠 Lessons Learned

Real-world findings from testing — what didn't work, the root cause analysis, and what actually fixed it. These failures are not embarrassments — they are the point. Real hardening is iterative. Compliance scanners validate at the **enforced policy level**, not at the raw registry level, and understanding that distinction is what separates a script that looks right from one that actually passes.

---

### 1. WN11-AC-000040 — Password Complexity: Registry vs secedit

**First attempt — Direct Registry Write (❌ Failed Tenable re-scan)**

```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "PasswordComplexity" -Value 1
```

The registry key was correctly set and visible in a `secedit /export` — but Tenable still flagged it as a failure. Writing directly to the LSA registry key does not commit the change through Windows Security Policy. Tenable validates at the **effective policy level**, not raw registry values.

**Fix — secedit Policy Apply (✅ Confirmed passing Scan 2 onward)**

```powershell
secedit /export /cfg $tempFile
(Get-Content $tempFile) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" | Set-Content $tempFile
secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY
```

Exporting, modifying, and re-applying via `secedit` commits the change through the proper Windows Security Policy channel — which is what compliance scanners actually validate against.

> ⚠️ **Key Takeaway:** For password and account policy settings, always use `secedit` or Group Policy. Never write directly to the registry and expect a compliance scan to pass — the scanner checks the **enforced policy**, not the raw key.

---

### 2. WN11-CC-000330 & WN11-CC-000335 — WinRM: Service vs Client Registry Path

Both of these STIGs were scripted, applied, and looked correct — but failed Tenable scans 1 through 3. Both failed for the same root cause.

**First attempt — Wrong registry hive (❌ Failed Scan 1–3)**

```powershell
# Applied to \WinRM\Service — WRONG
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
Set-ItemProperty -Path $registryPath -Name "AllowBasic" -Value 0           # CC-000330
Set-ItemProperty -Path $registryPath -Name "AllowUnencryptedTraffic" -Value 0  # CC-000335
```

The `\Service` path controls **incoming** WinRM connections. The STIG requirement targets **outbound** client behavior — meaning the scanner was checking a completely different registry key than the one being set.

**Fix — Correct Client path (✅ CC-000330 passes Scan 4; CC-000335 passes Final)**

```powershell
# Applied to \WinRM\Client — CORRECT
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
Set-ItemProperty -Path $registryPath -Name "AllowBasic" -Value 0           # CC-000330
Set-ItemProperty -Path $registryPath -Name "AllowUnencryptedTraffic" -Value 0  # CC-000335
```

> ⚠️ **Key Takeaway:** WinRM has two separate policy branches — `\Service` (incoming) and `\Client` (outgoing). DISA STIGs WN11-CC-000330 and WN11-CC-000335 both target the **Client** side. Setting the Service path produces no compliance result because the scanner validates the Client path. Always check the STIG check text carefully to identify which WinRM component is in scope.

---

### 3. WN11-AU-000585 — Command Line Logging: Registry Alone Is Not Enough

This one was more subtle. The registry key was correct. The path was correct. The value was correct. And it still failed.

**First attempt — Registry only (❌ Failed)**

```powershell
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
Set-ItemProperty -Path $registryPath -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1
```

The registry setting enables command-line data to be **included** in process creation events — but only if Process Creation auditing is actually **enabled** in the first place. Without the `auditpol` step, there are no events being generated at all, so the registry flag has nothing to attach to.

**Fix — Two-step approach: Registry + auditpol (✅ Confirmed passing)**

```powershell
# Step 1 — Enable command line data in process creation events
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
Set-ItemProperty -Path $registryPath -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1

# Step 2 — Enable Process Creation auditing via auditpol
auditpol /set /subcategory:"Process Creation" /failure:enable
```

> ⚠️ **Key Takeaway:** The registry flag and `auditpol` are two separate controls that work together. The registry key controls **what** gets logged. `auditpol` controls **whether** logging happens at all. Both must be set. Applying only one is a silent failure — the system appears configured but the scanner sees no evidence of active auditing.

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
