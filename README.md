# 🔌 NI Multisim 14.0 Linux Installer
> Automated installer for **NI Multisim 14.0** on Linux via Wine.

Built for the redpilled breed of engineers and students who rely on NI Multisim every day but run Linux as their primary OS. This repository provides the tools, tweaks, and compatibility setup needed to make Multisim usable on a Linux daily-driver environment without the usual headaches.

**Authors:** Giovanni De Rosa, Lorenzo Pappalardo

---

## 📋 Table of Contents

- [Overview](#overview)
- [Supported Distributions](#supported-distributions)
- [Prerequisites](#prerequisites)
- [How It Works](#how-it-works)
- [Usage](#usage)
- [Installation Steps (What the Script Does)](#installation-steps-what-the-script-does)
- [Notes & Known Issues](#notes--known-issues)

---

## Overview

This bash script automates the full process of installing **NI Circuit Design Suite 14.0 (Multisim)** on Linux. It handles Wine installation, a dedicated 32-bit Wine prefix, dependency setup, and the Multisim installer execution — all in a single run across all supported distros.

---

## Supported Distributions

| Distribution Family | Tested Distros |
|---|---|
| 🔵 Arch Linux | Arch, Manjaro, EndeavourOS |
| 🟠 Debian / Ubuntu | Debian, Ubuntu, Linux Mint |
| 🔴 Fedora / RHEL | Fedora, CentOS |
| 🟢 openSUSE | openSUSE Leap, Tumbleweed |

---

## Prerequisites
 `wget`, `unzip` available on your system


---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/your-username/multisim-linux-installer.git
cd multisim-linux-installer
```

### 2. Make the script executable

```bash
chmod +x install_multisim.sh
```

### 3. Run the installer

```bash
./install_multisim.sh
```

> ⚠️ **Do not run as root.** The script uses `sudo` internally where needed.

---

## How it works (What the Script Does)

### Distro Detection
Reads `/etc/os-release` to identify your distribution family and selects the correct install path.

### Remove Conflicting Packages
Checks for and removes any existing Wine installations that may conflict with the version required by Multisim.

### Install Wine

| Distro | Method |
|---|---|
| **Arch** | Chaotic AUR (`wine-stable`, recommended) or AUR via `yay` |
| **Debian/Ubuntu/Mint** | `apt` — installs `wine`, `wine32`, `wine64`, `libwine` |
| **Fedora** | `dnf` — installs `wine`, `wine-core.i686`  |
| **openSUSE** | `zypper` — installs `wine` |

### Wine Prefix Setup
Creates a dedicated **32-bit Wine prefix** at `~/.multisim32`, isolated from your default Wine environment, configured with Windows XP compatibility mode.
> Windows XP compatibility mode is essential to make multisim work

```bash
WINEARCH=win32 WINEPREFIX="$HOME/.multisim32" winecfg -v winxp
```

### Wine Dependencies
Installs required components via `winetricks`:

- `corefonts` — Microsoft core fonts
- `mdac27` — Microsoft Data Access Components 2.7
- `jet40` — Microsoft Jet 4.0 database engine

### Download & Install Multisim
Downloads the official NI Circuit Design Suite 14.0 installer from National Instruments' servers through wget, extracts it, and runs it through Wine.

### Desktop Launcher Fix *(Debian/Fedora)*
Automatically patches the `.desktop` file created by the installer to ensure it uses the correct Wine prefix and `wine32` binary when launched from your application menu.

### Cleanup
Removes the downloaded ZIP and extracted installer directory.

### Reboot
Asks for system reboot, essential for the later functioning of the application.

---

## Notes & Known Issues

- **Arch Linux users** are prompted whether to use Chaotic AUR (fast, pre-built) or compile from AUR (slow). Chaotic AUR is strongly recommended.
- The Wine prefix is stored at `~/.multisim32` and is completely separate from any existing Wine setup you may have.
- A **system reboot** is recommended after installation.
- If Multisim does not appear in your application launcher after install, try running:
  ```bash
  update-desktop-database ~/.local/share/applications
  ```
- Only the subsequent distros were tested: Arch Linux, Ubuntu, Fedora, openSUSE Tumbleweed.
---

## License

This project is released for educational and personal use. NI Multisim is proprietary software owned by National Instruments — ensure you have a valid license before use.

## 📌 Nota di presentazione
Capolavoro presentato da Giovanni De Rosa e Lorenzo Pappalardo sulla Piattaforma Unica – DD MM 2026.
