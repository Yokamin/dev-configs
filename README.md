# Dev Environment Setup Guide

### Description
Small script to set up PowerShell 7 with a git tracked profile and modules.

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

## Steps to Run the Setup Script

### 1. **Clone the Repository**
Open your terminal and navigate to your home folder:  
```powershell
cd $HOME
```

Clone this repository:  
```powershell
git clone {link-to-repository}
```

Navigate to the scripts folder:  
```powershell
cd .\.dev-configs\Scripts\
```

---

### 2. **Run the PowerShell Setup Script**
**Set Execution Policy (to allow running the script):**  
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

**Run the script:**  
```powershell
.\SetupPowerShell.ps1
```

---

### 3. **What the Script Does**
- Ensures that PowerShell 7 is installed and running as Administrator  
- Sets PowerShell 7 as the default for Windows Terminal  
- Configures a custom PowerShell profile  
- Adds a custom modules folder to the `PSModulePath`  
- Reloads your PowerShell profile and relaunches Windows Terminal  

> **Note:** More details about the PowerShell profile and modules will be added soon.

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

---

## Directory Structure
```
.dev-configs/
│── PowerShell/
│   │── Modules/               # Custom PowerShell modules (currently empty)
│   └── Profiles/
│       └── Microsoft.PowerShell_profile.ps1  # PowerShell profile script
│── Scripts/
│   └── SetupPowerShell.ps1    # PowerShell setup script
└── README.md   # This document
```

---

## Future Plans
- Add pre-configured PowerShell modules and profiles  
- Provide sample VS Code settings and keybindings  
- Setup typical extensions in VSCode, perhaps add a "install extensions from list" command

