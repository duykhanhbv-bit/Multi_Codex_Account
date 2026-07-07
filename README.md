# Multi_Codex_Account

*Đọc bằng ngôn ngữ khác: [Tiếng Việt](README_VI.md)*

Portable multi-account launcher for Codex CLI on Windows.

This project provides four isolated Codex CLI profiles with separate state folders, simple account-specific launchers, and one-click project startup.

## Features

- Four isolated profiles: `account-1` to `account-4`
- Separate `CODEX_HOME` and per-account state under `state\account-N`
- `codex1.bat` to `codex4.bat` prompt once for a project path, then launch directly
- Terminal launch support with `codex1`, `codex2`, `codex3`, and `codex4`
- Public-safe packaging without bundled auth files
- Optional private packaging for trusted personal machines

## Requirements

- Windows
- Codex CLI installed on the target machine
- PowerShell available

This repository does not include the Codex application binary.

## Quick Start

1. Download or extract the bundle.
2. Run `codex1.bat`, `codex2.bat`, `codex3.bat`, or `codex4.bat`.
3. Enter the project path once, for example `E:\Antigravity\GOLD`.
4. If that account is not logged in yet, complete the login flow once.
5. The selected profile will be reused on later runs.

If you are already inside a project folder in a terminal, you can also run:

```powershell
codex1
```

Or launch a specific workspace directly:

```powershell
codex1 E:\Antigravity\GOLD
```

## Project Structure

- `codex1.bat` to `codex4.bat`: interactive launchers
- `open-account-1.cmd` to `open-account-4.cmd`: open a new window for a specific account
- `scripts\Start-CodexPortableAccount.ps1`: main launcher logic
- `state\account-N`: placeholder folders in the public repo; runtime profile data is created on first launch
- `status-all-accounts.cmd`: quick login status check

## Security

- Public builds should not include `auth.json` or `cap_sid`.
- Private builds may include active auth files and should be used only on trusted machines.
- Treat bundled auth files like passwords.

## License

See [COPYRIGHT-NDKBVH.txt](COPYRIGHT-NDKBVH.txt).
