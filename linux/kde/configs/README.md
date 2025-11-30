# KDE Configuration Backups

This directory contains backed up KDE configuration files.

## Purpose

When you run `backup_kde.sh`, your KDE configuration files from `~/.config/` will be copied here. This allows you to:

- Track KDE configuration changes in git
- Restore settings on a new machine
- Roll back to previous configurations
- Share your KDE setup across multiple systems

## Backup Process

```bash
cd ~/dotfiles/linux/kde
./backup_kde.sh
```

This will copy the following files from `~/.config/` to this directory:

- **kdeglobals** - Global KDE settings
- **kwinrc** - KWin window manager settings
- **kglobalshortcutsrc** - Global keyboard shortcuts
- **khotkeysrc** - Custom hotkeys
- **plasma-org.kde.plasma.desktop-appletsrc** - Panel and widgets
- **plasmarc** - Plasma shell settings
- **plasmashellrc** - Plasma shell configuration
- **kscreenlockerrc** - Screen locker settings
- **powermanagementprofilesrc** - Power management
- **ksmserverrc** - Session management
- **kcminputrc** - Input devices (keyboard, mouse)
- **kxkbrc** - Keyboard layouts

## Restore Process

```bash
cd ~/dotfiles/linux/kde
./restore_kde.sh
```

This will copy all config files from this directory back to `~/.config/`.

**Important:** After restoring, log out and log back in for all changes to take effect.

## Git Workflow

After backing up your configuration:

```bash
cd ~/dotfiles
git add linux/kde/configs/
git commit -m "Update KDE configuration"
git push
```

On a new machine:

```bash
cd ~/dotfiles
git pull
cd linux/kde
./quick-setup.sh  # Initial setup
./restore_kde.sh  # Restore your backed up configs
# Log out and log back in
```

## Notes

- This directory will be empty until you run `backup_kde.sh` for the first time
- The backup script will warn you if any config files are missing (this is normal for fresh installations)
- You should backup your configuration after making significant changes to your KDE setup
- Config files may contain absolute paths specific to your system

---

**Last updated:** 2025-11-30

