# Powershell profile and module setup

### Description
In case I am setting it up on a new pc or something, I'll try to keep this repo up-to-date as far as my profile/modules setup etc...

Also a quick guide for setting it up just in case

---

## Prerequisites

### 1. **Winget (Windows Package Manager)**  
**Check if `winget` is installed:**  
```powershell
winget --version
```

If you don't have `winget`, you can install it manually:  
- From the [GitHub Releases Page](https://github.com/microsoft/winget-cli/releases)  
- By installing the **App Installer** from the Microsoft Store  

---

### 2. **Git Installation**  
Install Git via `winget`:  
```powershell
winget install --id Git.Git --source winget --accept-source-agreements --accept-package-agreements
```

---

## Setup PowerShell

### 0. **Optional: Old install script**
The old install script would basically automate the process of installing PS7 and setting as admin, but it's a bit flaky and I don't care enough to keep it working.
It has an old version of README.md within its folder (old_install_script)

### 1. **Install latest PowerShell 7**
In PowerShell run:
```powershell
winget install --id Microsoft.Powershell --source winget --accept-source-agreements --accept-package-agreements
```

### 2. **Set PowerShell 7 as default and to run as admin**
In Windows Terminal:
1. Open the **Settings** tab and choose your newly installed PowerShell 7 as default
2. Open the **Profiles** settings for PowerShell 7:
- Enable **Run this profile as Administrator**
- Set starting directory to `%USERPROFILE%`
- Optional: Appearance > Color scheme > Solarized Dark

### 3. **Setup PowerShell Profile and Module**
Optional: Setup VSCode first for a better editor experience and opening files with `code`

1. Open up $PROFLIE: `code $PROFLIE`
2. Paste content from GitHub profile to here and save
- Should already have Chocolatey stuff added, double-check after installing chocolatey if it messed it up or duped lines in your profile
3. In explorer, navigate to `C:\Users\{your_user}\Documents\PowerShell\Modules`
- Paste modules from GitHub to Modules folder
- If Modules folder doesn't exist, simply create it

---

## Install Chocolatey package manager and FiraCode font

### 1. **Install Chocolatey package manager**
Run `Get-ExecutionPolicy` to see if you have privileges, or just straight to command:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
Run `choco` after install to confirm that it works

### 2. **FiraCode set-up**
Run `choco install firacode` to install

### 3. **Set FiraCode as font in terminal**
Restart terminal if already open
In terminal settings, go to your profile's settings and choose font FiraCode

---

## Python Setup Guide

### 1. **Check if Python is Installed**
Run one of the following commands to check your Python version:  
```powershell
python --version
python3 --version
py --version
```

### 2. **Install Python**
Download and install the latest version of Python from the [official website](https://www.python.org/).  
> **Important:** Remember to add Python to the PATH during installation and install as `py` for easier commands.  

### 3. **Update `pip`**
Ensure `pip` is installed and up to date:  
```powershell
py -m ensurepip --default-pip
py -m pip install --upgrade pip
```

> **Note:**  
> Upgrading Python may require:  
> - Recreating virtual environments (`venv`)  
> - Reinstalling Python packages  

---

## Visual Studio Code Setup Guide

### 1. **Install Visual Studio Code**
Use `winget` to install Visual Studio Code:  
```powershell
winget install -e --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
```

### 2. **Verify Command Line Access**
Open a new terminal and run `code` to ensure Visual Studio Code is available from the command line. If it doesn’t work, you may need to set it up manually from VS Code:  
- Open VS Code  
- Press `Ctrl+Shift+P` and type `Shell Command: Install 'code' command in PATH`

### 3. **Sync Settings and Extensions**
Sign into your Microsoft or GitHub account to enable settings sync and automatically install your extensions.  

> **Typical Extensions:**  
> - Python  
> - PowerShell  
> - Prettier  