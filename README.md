# NI-Multisim-14-for-Linux
Built for the redpilled breed of engineers and students who rely on NI Multisim every day but run Linux as their primary OS. This repository provides the tools, tweaks, and compatibility setup needed to make Multisim usable on a Linux daily-driver environment without the usual headaches.

# Multisim 14.0 Linux Installer

A cross-distro automated installer for **NI Multisim 14.0** using Wine.

Supports:

- Arch Linux
- Debian / Ubuntu / Linux Mint
- Fedora
- openSUSE

---

# Features

- Automatic Linux distro detection
- Wine installation and configuration
- Automatic 32-bit Wine prefix creation
- Installs required Winetricks dependencies
- Downloads and installs Multisim 14.0 automatically
- Fixes desktop launcher integration
- Cleans up installation files after install
- Optional reboot prompt

---

# Supported Distributions

| Distribution | Status |
|--------------|--------|
| Arch Linux | ✅ |
| Ubuntu | ✅ |
| Debian | ✅ |
| Linux Mint | ✅ |
| Fedora | ✅ |
| openSUSE | ✅ |

---

# Requirements

Before running the installer, ensure you have:

- Internet connection
- `sudo` privileges
- Bash shell
- At least 10 GB free disk space

---

# Installation

## Clone Repository

```bash
git clone https://github.com/yourusername/multisim-linux-installer.git
cd multisim-linux-installer
```

## Make Script Executable

```bash
chmod +x install_multisim.sh
```

## Run Installer

```bash
./install_multisim.sh
```

---

# What the Script Does

## 1. Detects Your Linux Distribution

The installer automatically identifies your distro family:

- Arch-based
- Debian-based
- Fedora-based
- openSUSE

---

## 2. Removes Conflicting Wine Packages

The script removes potentially conflicting Wine installations before proceeding.

Examples:

```bash
wine
wine32
wine64
winetricks
wine-gecko
wine-mono
```

---

## 3. Installs Wine

### Arch Linux

Options:

- Install `wine-stable` from Chaotic AUR
- Compile from AUR using `yay`

### Debian / Ubuntu / Mint

Installs:

```bash
wine
wine32
wine64
libwine
winetricks
```

### Fedora

- Optional RPM Fusion setup
- Wine + 32-bit support installation

### openSUSE

Installs Wine directly through `zypper`

---

# Wine Prefix Configuration

The installer creates a dedicated 32-bit Wine environment:

```bash
WINEPREFIX="$HOME/.multisim32"
WINEARCH=win32
```

Windows version is configured as:

```text
Windows XP
```

---

# Winetricks Dependencies

The following components are installed automatically:

```bash
corefonts
mdac27
jet40
```

These are required for Multisim compatibility.

---

# Automatic Multisim Download

The installer downloads:

```text
NI_Circuit_Design_Suite_14_0.zip
```

Directly from National Instruments servers.

---

# Installation Process

The installer:

1. Downloads Multisim
2. Extracts installer files
3. Launches setup through Wine
4. Waits for completion
5. Stops Wine services
6. Fixes desktop launcher entries

---

# Desktop Launcher Fix

For Debian/Fedora systems, the script automatically fixes:

```text
~/.local/share/applications/
```

So Multisim launches with the correct Wine prefix.

---

# Cleanup

Temporary installation files are removed automatically:

```bash
multisim_installer/
NI_Circuit_Design_Suite_14_0.zip
```

---

# Final Step

At the end of installation:

- A reboot is recommended
- Optional automatic restart prompt appears

---

# Example Output

```text
=======================================
✅ Multisim 14.0 installation complete!
A reboot of your machine is recommended
=======================================
```

---

# Repository Structure

```text
.
├── install_multisim.sh
├── README.md
└── LICENSE
```

---

# Notes

- Multisim 14.0 is a Windows application and runs through Wine.
- Compatibility may vary depending on distro version and GPU drivers.
- Wayland users may experience graphical issues; X11 is recommended.

---

# Troubleshooting

## Wine Crashes

Try:

```bash
wineserver -k
```

Then rerun Multisim.

---

## Missing Fonts or UI Issues

Reinstall Winetricks dependencies:

```bash
winetricks corefonts mdac27 jet40
```

---

## Launcher Not Working

Run manually:

```bash
WINEPREFIX="$HOME/.multisim32" wine Multisim.exe
```

---

# Authors

- Giovanni De Rosa
- Lorenzo Pappalardo

---

# License

This project is distributed under the MIT License.

---

# Disclaimer

NI Multisim is proprietary software owned by National Instruments.

This installer only automates the setup process on Linux systems and does not distribute Multisim itself.


# 📌 Nota di presentazione
Capolavoro presentato da Giovanni De Rosa e Lorenzo Pappalardo sulla Piattaforma Unica – DD MM 2026.
