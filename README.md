# NI-Multisim-14-for-Linux
Built for the redpilled breed of engineers and students who rely on NI Multisim every day but run Linux as their primary OS. This repository provides the tools, tweaks, and compatibility setup needed to make Multisim usable on a Linux daily-driver environment without the usual headaches.

# ⚡ Automated Multisim 14.0 Installer for Linux

![Supported OS: Linux](https://img.shields.io/badge/Supported_OS-Linux-orange.svg)
![Bash](https://img.shields.io/badge/Language-Bash-blue.svg)

A robust, automated Bash script to seamlessly install **NI Multisim 14.0** on various Linux distributions using Wine.

**Authors:** Giovanni De Rosa, Lorenzo Pappalardo

---

## 🚀 Overview

Running Windows-native engineering software like NI Multisim on Linux typically requires tedious manual configuration of Wine, dependencies, and architecture settings. 

This script automates the entire process end-to-end. It detects your Linux distribution, resolves Wine package conflicts, configures a clean 32-bit Wine environment, installs necessary Windows libraries, and executes the official Multisim 14.0 installer.

### ✨ Features
* **Intelligent Distro Detection:** Automatically adapts the installation method based on your OS.
* **Conflict Resolution:** Detects and removes broken or conflicting Wine packages before installation.
* **Isolated Environment:** Creates a dedicated 32-bit Wine prefix (`~/.multisim32`) ensuring it doesn't break your other Wine applications.
* **Dependency Management:** Automatically fetches and installs required Windows components (`corefonts`, `mdac27`, `jet40`) via `winetricks`.
* **Desktop Integration:** Automatically fixes the `.desktop` launcher so you can start Multisim right from your app menu.
* **Auto-Cleanup:** Removes heavy installation zips and extracted folders once finished.

---

## 🐧 Supported Distributions

This script natively supports and has been tested on the following distribution families:
* 🟢 **Arch Linux** (Includes EndeavourOS, Manjaro, etc. Features optional Chaotic AUR integration for faster installs).
* 🔴 **Debian Family** (Debian, Ubuntu, Linux Mint, Pop!_OS).
* 🔵 **Fedora** (Includes optional RPM Fusion setup).
* 🦎 **openSUSE** (Leap & Tumbleweed).

---

## 🛠️ Usage Instructions

### 1. Download the script
Clone this repository or download the script directly to your local machine:
```bash
git clone [https://github.com/YOUR-USERNAME/multisim-linux-installer.git](https://github.com/YOUR-USERNAME/multisim-linux-installer.git)
cd multisim-linux-installer


# 📌 Nota di presentazione
Capolavoro presentato da Giovanni De Rosa e Lorenzo Pappalardo sulla Piattaforma Unica – DD MM 2026.
