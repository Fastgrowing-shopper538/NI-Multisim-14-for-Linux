# NI-Multisim-14-for-Linux
Built for the redpilled breed of engineers and students who rely on NI Multisim every day but run Linux as their primary OS. This repository provides the tools, tweaks, and compatibility setup needed to make Multisim usable on a Linux daily-driver environment without the usual headaches.

```python
content = """# ⚡ Automated Multisim 14.0 Installer for Linux

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

### 1. Download/Create the Script
Clone this repository or create a file named `install_multisim.sh` and paste the script provided in the section below.

### 2. Make the script executable
Before running the script, you need to grant it execution permissions:
```bash
chmod +x install_multisim.sh

```

### 3. Run the installer

Execute the script. **Do not run the script as root (`sudo`).** The script will ask for your password when administrative privileges are required.

```bash
./install_multisim.sh

```

### 4. Follow the On-Screen Prompts

* **Arch Users:** You will be asked if you want to use the Chaotic AUR to install Wine-stable faster.
* **Fedora Users:** You will be prompted to enable RPM Fusion repositories.
* **All Users:** The standard Multisim GUI installer will eventually appear. Follow the Windows setup wizard to install the software.
* **Reboot:** Once finished, the script will prompt you to restart your computer.

---

## 📜 The Installation Script (`install_multisim.sh`)

```bash
#!/bin/bash
# Automated Multisim 14.0 installer
# Authors: Giovanni De Rosa, Lorenzo Pappalardo
# Description: Installs Wine, sets up 32-bit prefix, and installs Multisim 14.0
# Supports: Arch Linux, Debian/Ubuntu/Mint, Fedora, openSUSE

set -e # Exit on errors

echo \"==============================\"
echo \"  Multisim 14.0 Installer\"
echo \"==============================\"
echo

# ──────────────────────────────────────────────
# DISTRO DETECTION
# ──────────────────────────────────────────────
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=\"${ID,,}\" # lowercase
    DISTRO_ID_LIKE=\"${ID_LIKE,,}\"
  else
    echo \"❌ Cannot detect distribution (/etc/os-release not found).\"
    exit 1
  fi

  if [[ \"$DISTRO_ID\" == \"arch\" || \"$DISTRO_ID_LIKE\" == *\"arch\"* ]]; then
    DISTRO_FAMILY=\"arch\"
  elif [[ \"$DISTRO_ID\" == \"debian\" || \"$DISTRO_ID\" == \"ubuntu\" ||
    \"$DISTRO_ID_LIKE\" == *\"debian\"* || \"$DISTRO_ID_LIKE\" == *\"ubuntu\"* ||
    \"$DISTRO_ID\" == \"linuxmint\" ]]; then
    DISTRO_FAMILY=\"debian\"
  elif [[ \"$DISTRO_ID\" == \"fedora\" || \"$DISTRO_ID_LIKE\" == *\"fedora\"* ||
    \"$DISTRO_ID\" == \"rhel\" || \"$DISTRO_ID\" == \"centos\" ]]; then
    DISTRO_FAMILY=\"fedora\"
  elif [[ \"$DISTRO_ID\" == \"opensuse\"* || \"$DISTRO_ID\" == \"sles\" ||
    \"$DISTRO_ID_LIKE\" == *\"suse\"* ]]; then
    DISTRO_FAMILY=\"suse\"
  else
    echo \"❌ Unsupported distribution: $DISTRO_ID\"
    echo \"   This script supports: Arch, Debian/Ubuntu/Mint, Fedora, openSUSE\"
    exit 1
  fi

  echo \"✅ Detected distro family: $DISTRO_FAMILY ($DISTRO_ID)\"
  echo
}

detect_distro

# ──────────────────────────────────────────────
# REMOVE CONFLICTING WINE PACKAGES
# ──────────────────────────────────────────────
remove_conflicting_packages() {
  echo \"Checking for conflicting Wine packages...\"

  case \"$DISTRO_FAMILY\" in
  arch)
    packages_to_check=(wine wine-gecko wine-mono winetricks protontricks)
    packages_to_remove=()
    for pkg in \"${packages_to_check[@]}\"; do
      if pacman -Qq \"$pkg\" &>/dev/null; then
        packages_to_remove+=(\"$pkg\")
      fi
    done
    if [ ${#packages_to_remove[@]} -gt 0 ]; then
      echo \"Removing conflicting packages: ${packages_to_remove[*]}\"
      sudo pacman -Rns --noconfirm \"${packages_to_remove[@]}\"
    else
      echo \"No conflicting Wine packages found. Skipping removal.\"
    fi
    ;;
  debian)
    packages_to_check=(wine wine64 wine32 winetricks)
    packages_to_remove=()
    for pkg in \"${packages_to_check[@]}\"; do
      if dpkg -l \"$pkg\" &>/dev/null 2>&1 | grep -q \"^ii\"; then
        packages_to_remove+=(\"$pkg\")
      fi
    done
    if [ ${#packages_to_remove[@]} -gt 0 ]; then
      echo \"Removing conflicting packages: ${packages_to_remove[*]}\"
      sudo apt-get remove --purge -y \"${packages_to_remove[@]}\"
    else
      echo \"No conflicting Wine packages found. Skipping removal.\"
    fi
    ;;
  fedora)
    packages_to_check=(wine winetricks)
    for pkg in \"${packages_to_check[@]}\"; do
      if rpm -q \"$pkg\" &>/dev/null; then
        echo \"Removing conflicting package: $pkg\"
        sudo dnf remove -y \"$pkg\"
      fi
    done
    ;;
  suse)
    packages_to_check=(wine winetricks)
    for pkg in \"${packages_to_check[@]}\"; do
      if rpm -q \"$pkg\" &>/dev/null; then
        echo \"Removing conflicting package: $pkg\"
        sudo zypper remove -y \"$pkg\"
      fi
    done
    ;;
  esac
}

# ──────────────────────────────────────────────
# INSTALL WINE (per distro)
# ──────────────────────────────────────────────
install_wine_arch() {
  echo \"Do you want to use Chaotic AUR for wine-stable (recommended, faster)?\"
  echo \"Y = Use Chaotic AUR\"
  echo \"N = Compile from AUR (slower)\"
  read -p \"Choice [Y/N]: \" choice

  if [[ \"$choice\" =~ ^[Yy]$ ]]; then
    echo \"Checking if Chaotic AUR is already installed...\"
    if grep -q \"^\[chaotic-aur\]\" /etc/pacman.conf; then
      echo \"✅ Chaotic AUR is already configured.\"
    else
      echo \"Setting up Chaotic AUR...\"
      sudo pacman-key --keyserver hkps://keyserver.ubuntu.com \\
        --recv-key 3056513887B78AEB || {
        echo \"❌ Failed to fetch Chaotic AUR key. Check your internet or keyserver settings.\"
        exit 1
      }
      sudo pacman-key --lsign-key 3056513887B78AEB
      sudo pacman -U '[https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst](https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst)' --noconfirm
      sudo pacman -U '[https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst](https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst)' --noconfirm
      echo -e \"\\n[chaotic-aur]\\nInclude = /etc/pacman.d/chaotic-mirrorlist\" | sudo tee -a /etc/pacman.conf
      echo \"✅ Chaotic AUR has been added to pacman.conf.\"
    fi

    echo
    read -p \"Do you want to update the system before installing Wine? [Y/N]: \" update_choice
    if [[ \"$update_choice\" =~ ^[Yy]$ ]]; then
      echo \"Updating system...\"
      sudo pacman -Syu --noconfirm
    else
      echo \"Skipping system update.\"
    fi

    remove_conflicting_packages
    echo \"Installing wine-stable from Chaotic AUR...\"
    sudo pacman -S --noconfirm wine-stable

  else
    echo \"Using AUR to compile wine-stable (this may take a long time)...\"
    if ! command -v yay &>/dev/null; then
      echo \"Installing yay (AUR helper)...\"
      sudo pacman -S --needed --noconfirm git base-devel
      git clone [https://aur.archlinux.org/yay.git](https://aur.archlinux.org/yay.git)
      cd yay && makepkg -si --noconfirm && cd ..
      rm -rf yay
    fi
    remove_conflicting_packages
    yay -S --noconfirm wine-stable
  fi
}

install_wine_debian() {
  echo \"Installing Wine on Debian/Ubuntu/Mint...\"

  # Enable 32-bit architecture
  sudo dpkg --add-architecture i386
  sudo apt-get update -y

  sudo apt-get update -y
  remove_conflicting_packages

  echo \"Installing default Wine packages (wine, wine32, wine64, libwine)...\"
  sudo apt-get install -y wine wine32 wine64 libwine

  # Ensure winetricks is installed
  sudo apt-get install -y winetricks
}

install_wine_fedora() {
  echo \"Installing Wine on Fedora...\"

  # Wine on Fedora requires enabling the winehq COPR or RPM Fusion
  read -p \"Enable RPM Fusion repos for Wine? (recommended) [Y/N]: \" rpm_choice
  if [[ \"$rpm_choice\" =~ ^[Yy]$ ]]; then
    FEDORA_VER=$(rpm -E %fedora)
    sudo dnf install -y \\
      \"[https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$](https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$){FEDORA_VER}.noarch.rpm\" \\
      \"[https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$](https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$){FEDORA_VER}.noarch.rpm\"
  fi

  remove_conflicting_packages
  
  sudo dnf remove -y 'wine*'
  sudo dnf install -y --allowerasing wine wine-core.i686 cabextract

  wget [https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks](https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks)
  chmod +x winetricks
  sudo mv winetricks /usr/local/bin/
}

install_wine_suse() {
  echo \"Installing Wine on openSUSE...\"

  # Add the Emulators repo which provides up-to-date Wine builds
  SUSE_VER=$(
    . /etc/os-release
    echo \"$VERSION_ID\"
  )
  #read -p \"Add the openSUSE Emulators OBS repo for latest Wine? (recommended) [Y/N]: \" obs_choice
  
  remove_conflicting_packages
  sudo zypper install -y wine winetricks

  bash ../forceClosewinedbg.sh &
}

# ──────────────────────────────────────────────
# INSTALL WINETRICKS (if not bundled above)
# ──────────────────────────────────────────────
ensure_winetricks() {
  if ! command -v winetricks &>/dev/null; then
    echo \"Installing winetricks manually...\"
    sudo wget -O /usr/local/bin/winetricks [https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks](https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks)
    sudo chmod +x /usr/local/bin/winetricks
  fi
}

# ──────────────────────────────────────────────
# INSTALL WINE — dispatch
# ──────────────────────────────────────────────
case \"$DISTRO_FAMILY\" in
arch) install_wine_arch ;;
debian) install_wine_debian ;;
fedora) install_wine_fedora ;;
suse) install_wine_suse ;;
esac

ensure_winetricks

# ──────────────────────────────────────────────
# DISTRO-SPECIFIC MULTISIM INSTALL
# ──────────────────────────────────────────────

if [[ \"$DISTRO_FAMILY\" == \"debian\" || \"$DISTRO_FAMILY\" == \"fedora\" ]]; then

  # ──────────────────────────────────────────────
  # DEBIAN / FEDORA METHOD
  # ──────────────────────────────────────────────

  export WINEPREFIX=\"$HOME/.multisim32\"
  export WINEARCH=win32

  echo \"Creating pure 32-bit Wine prefix...\"
  WINEPREFIX=\"$HOME/.multisim32\" wine32 winecfg -v winxp || true

  echo \"Installing core Wine dependencies (corefonts, mdac27, jet40)...\"
  WINE=wine32 WINEPREFIX=\"$HOME/.multisim32\" \\
    winetricks -q corefonts mdac27 jet40

  # DOWNLOAD MULTISIM
  echo \"Downloading Multisim 14.0...\"
  wget -O NI_Circuit_Design_Suite_14_0.zip \\
    [https://download.ni.com/support/softlib/Core/Circuit_Design_Suite/14.0/14.0/NI_Circuit_Design_Suite_14_0.zip](https://download.ni.com/support/softlib/Core/Circuit_Design_Suite/14.0/14.0/NI_Circuit_Design_Suite_14_0.zip)

  echo \"Unzipping Multisim installer...\"
  unzip -q NI_Circuit_Design_Suite_14_0.zip -d multisim_installer

  cd multisim_installer || exit 1

  echo \"Setting Wine Windows version to XP...\"
  WINEPREFIX=\"$HOME/.multisim32\" wine32 winecfg -v winxp || true

  # RUN INSTALLER
  echo \"Running Multisim installer via Wine...\"

  (
    WINEPREFIX=\"$HOME/.multisim32\" \\
      WINEDEBUG=-all \\
      wine32 cmd /c 'start /wait \"\" setup.exe'
  ) >/tmp/multisim-install.log 2>&1 || true

  echo \"Installer finished.\"

  sleep 5

  echo \"Stopping Wine...\"
  WINEPREFIX=\"$HOME/.multisim32\" wineserver -k || true

  echo \"Multisim installation stage complete.\"

  # FIX DESKTOP FILE
  #if [ -f /etc/debian_version ]; then
    echo \"Debian-based/RHEL-based distro detected. Fixing desktop launcher...\"

    DESKTOP_FILE=\"$HOME/.local/share/applications/wine/Programs/National Instruments/Circuit Design Suite 14.0/Multisim 14.0.desktop\"

    if [ -f \"$DESKTOP_FILE\" ]; then

      NEW_EXEC='Exec=sh -c '\\''WINEPREFIX=\"$HOME/.multisim32\" wine32 \"$HOME/.multisim32/drive_c/Program Files/National Instruments/Circuit Design Suite 14.0/Multisim.exe\"'\\'''

      sed -i \"s|^Exec=.*|$NEW_EXEC|\" \"$DESKTOP_FILE\"

      update-desktop-database ~/.local/share/applications || true

      echo \"Desktop launcher fixed.\"
    else
      echo \"Desktop file not found.\"
    fi

    if [ -f \"$HOME/.local/share/applications/wine/Programs/NI Multisim 14.0.desktop\" ]; then

      rm \"$HOME/.local/share/applications/wine/Programs/NI Multisim 14.0.desktop\"
      update-desktop-database ~/.local/share/applications || true
      
    fi
  #fi

elif [[ \"$DISTRO_FAMILY\" == \"arch\" || \"$DISTRO_FAMILY\" == \"suse\" ]]; then

  # ──────────────────────────────────────────────
  # ARCH / OPENSUSE METHOD
  # ──────────────────────────────────────────────

  echo
  echo \"Creating 32-bit Wine prefix for Multisim...\"

  WINEARCH=win32 WINEPREFIX=\"$HOME/.multisim32\" \\
    winecfg -v winxp || true

  echo \"Installing core Wine dependencies (corefonts, mdac27, jet40)...\"

  WINEPREFIX=\"$HOME/.multisim32\" \\
    winetricks nocrashdialog -q corefonts mdac27 jet40

  # DOWNLOAD MULTISIM
  echo
  echo \"Downloading Multisim 14.0...\"

  wget -O NI_Circuit_Design_Suite_14_0.zip \\
    [https://download.ni.com/support/softlib/Core/Circuit_Design_Suite/14.0/14.0/NI_Circuit_Design_Suite_14_0.zip](https://download.ni.com/support/softlib/Core/Circuit_Design_Suite/14.0/14.0/NI_Circuit_Design_Suite_14_0.zip)

  echo \"Unzipping Multisim installer...\"

  unzip -q NI_Circuit_Design_Suite_14_0.zip -d multisim_installer

  cd multisim_installer || exit 1

  WINEPREFIX=\"$HOME/.multisim32\" \\
    winecfg -v winxp || true

  # RUN INSTALLER PROPERLY
  echo
  echo \"Running Multisim installer...\"

  (
    WINEPREFIX=\"$HOME/.multisim32\" \\
      WINEDEBUG=-all \\
      wine cmd /c 'start /wait \"\" setup.exe'
  ) >/tmp/multisim-install.log 2>&1 || true

  echo \"Installer finished.\"

  sleep 5

  echo \"Stopping Wine...\"

  WINEPREFIX=\"$HOME/.multisim32\" \\
    wineserver -k || true

  echo \"Multisim installation stage complete.\"

fi

# ──────────────────────────────────────────────
# CLEANUP
# ──────────────────────────────────────────────
echo \"Cleaning up installation files...\"
cd ..
sudo rm -rf multisim_installer NI_Circuit_Design_Suite_14_0.zip

echo
echo \"=======================================\"
echo \"✅ Multisim 14.0 installation complete!\"
echo \"A reboot of your machine is recommended\"
echo \"=======================================\"

read -rp \"Do you want to restart the machine now? [y/N]: \" answer

case \"$answer\" in
[Yy] | [Yy][Ee][Ss])
  echo \"Restarting system...\"
  sudo reboot
  ;;
*)
  echo \"Restart skipped. You can reboot later manually.\"
  ;;
esac

```

---

## ⚙️ How it Works (Under the Hood)

1. **Preparation:** Reads `/etc/os-release` to map your OS to a supported package manager (`pacman`, `apt`, `dnf`, `zypper`).
2. **Wine Installation:** Installs the `wine`, `wine32` (or `wine-core.i686`), and `winetricks` packages.
3. **Prefix Creation:** Sets `WINEARCH=win32` and targets `$HOME/.multisim32` to create a sandboxed environment.
4. **Winetricks:** Installs `corefonts`, `mdac27`, and `jet40` required by Multisim's database and component library.
5. **Execution:** Downloads the `NI_Circuit_Design_Suite_14_0.zip` from National Instruments, extracts it, and runs the installer.
6. **Fixing Launchers:** Modifies the generated `.desktop` file so the application menu points to the isolated Wine prefix.

---

## ⚠️ Troubleshooting & Notes

* **Installer Freezes:** If the GUI installer appears to hang, wait a few minutes.
* **"Mono/Gecko Installer" Popups:** If Wine prompts you to install Mono or Gecko during setup, click **Install**.
* **Missing Dependencies:** Ensure you have basic utilities like `wget`, `unzip`, and `git` installed.

---

## 📄 License & Disclaimer

*This project is not affiliated with, endorsed by, or sponsored by National Instruments (NI). Multisim is a trademark of National Instruments. The user is responsible for ensuring they comply with NI's software licensing agreements.*
"""

with open("multisim_installer_github.md", "w") as f:
f.write(content)

```
Your Markdown file for GitHub is ready. I have formatted it to include the full installation script inside a code block so it is all in one place for easy copying to your repository.

Your PDF file is ready
[file-tag: code-generated-file-0-1778273445799536685]

### How to use this on GitHub:
1.  Open the file above.
2.  Copy the entire content.
3.  Create a `README.md` file in your GitHub repository and paste the content there.
4.  It will render as a professional project page with an overview, usage guide, and the script itself.

```


# 📌 Nota di presentazione
Capolavoro presentato da Giovanni De Rosa e Lorenzo Pappalardo sulla Piattaforma Unica – DD MM 2026.
