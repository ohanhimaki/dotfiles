# Olli's Dotfiles

## Project Overview

This repository contains my personal dotfiles for configuring and streamlining development environments on various platforms including Linux, Windows, and WSL. From setting up Neovim configurations to creating customization scripts for terminal usage, this repository documents tools I use to manage my workflow efficiently.

## Table of Contents

1. Quick Setup
2. Windows Configuration
   - Work
   - Home
3. Linux Configuration
   - Work
   - Home
4. Features
5. Custom Scripts
6. Ideas & Future Plans

---

### **1. Quick Setup**

To get started, clone or download the repository:

```bash
git clone --recursive https://github.com/olli/dotfiles.git ~/dotfiles
```

Follow the installation instructions in the subdirectories for different configurations.

---

### **2. Windows Configuration**

#### **Work**
Use `bootstrap.ps1` to install profiles for work by running:
```powershell
./bootstrap.ps1 -p "work"
```

Profiles here include work-specific gitconfig and other tools optimized for a corporate environment.

#### **Home**
Use `bootstrap.ps1` to install profiles for home use:
```powershell
./bootstrap.ps1 -p "home"
```

This includes personal gitconfig and settings tailored for casual development.

---

### **3. Linux Configuration**

#### **Work**
Grant execute permissions and run for work-specific setups:
```bash
chmod +x bootstrap.sh
sudo ./bootstrap.sh -p "work"
```

- Work-specific gitconfig is applied here.
- Additional tools for working in enterprise environments are included.

#### **Home**
To set up for home use:
```bash
chmod +x bootstrap.sh
sudo ./bootstrap.sh -p "home"
```

- Personal gitconfig and utilities for home development.
- Fewer enterprise-focused tools.

---

### **4. Features**

- **Neovim Plugins:** Optimized for efficient coding with support for plugins like `Copilot`, and `Telescope`.
- **Scripting:** Automation scripts for backups, updates, and environment setup.
- **Cross-Platform Profiles:** Different gitconfig and aliases tailored to work/home scenarios.

---

### **5. Custom Scripts**

Below are the major scripts included:

- `backup.sh`: Automates the backup of configuration files.
- `update.sh`: Keeps dependencies and tools up-to-date.
- `bootstrap`: Sets up the environment based on the profile you choose.

---

### **6. Ideas & Future Plans**

This section is dedicated to brainstorming and work-in-progress ideas I want to integrate into my workflow.

#### **Current Ideas**

- Comparing and unifying **Rider IDE** settings with **Vim/Nvim** configurations.
- Better organization of shared aliases for both Windows and Linux environments.
- Evaluating further differentiation between home and work configurations.
- Bash historia
- Mangohud alt + x toggle

Feel free to add more ideas as my workflow evolves.

---

### Acknowledgments

Special thanks to [Christian Rondeau’s dotfiles](https://github.com/christianrondeau/dotfiles) for inspiration!

