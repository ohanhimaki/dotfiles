# Awesome WM → KDE Plasma Migration Plan

This document outlines the migration plan for transferring settings and workflows from Awesome WM to KDE Plasma.

## 🎯 Overview

**Goal:** Replicate the Awesome WM experience in KDE Plasma while leveraging KDE's additional features.

**Current Setup:**
- **Theme:** OneDark color scheme
- **Terminal:** Kitty with OneDark theme
- **Launcher:** Rofi with OneDark theme
- **Font:** FiraCode Nerd Font Mono
- **Layouts:** Tiling (tile, max)
- **Custom widgets:** Battery, Audio, Spotify

---

## 📋 Migration Checklist

### 1. 🎨 Theme & Appearance

#### Colors (OneDark)
- [ ] Install/create KDE OneDark color scheme
  - Background: `#282c34` / `#21252b`
  - Foreground: `#abb2bf`
  - Accent: `#61afef` (blue)
  - Secondary colors: red `#e06c75`, green `#98c379`, yellow `#e5c07b`, purple `#c678dd`, cyan `#56b6c2`

**KDE Settings Location:**
- System Settings → Appearance → Colors
- Consider: Breeze Dark with custom tweaks or find OneDark KDE theme

#### Fonts
- [x] Already using FiraCode Nerd Font Mono
- [ ] Set in KDE: System Settings → Appearance → Fonts
  - General: FiraCode Nerd Font 10pt
  - Fixed width: FiraCode Nerd Font Mono 10pt
  - Small: FiraCode Nerd Font 9pt
  - Toolbar: FiraCode Nerd Font 10pt
  - Menu: FiraCode Nerd Font 10pt
  - Window title: FiraCode Nerd Font Bold 10pt

#### Window Decorations
- [ ] Minimal window borders (2px in Awesome)
- [ ] Configure in: System Settings → Appearance → Window Decorations
- [ ] Consider Breeze with minimal decorations or "Sierra Breeze Enhanced"

#### Panel/Taskbar
- [ ] Configure top panel similar to Awesome WM bar
- [ ] Add widgets: Application Launcher, Task Manager, System Tray, Clock
- [ ] Optional custom widgets: Battery (if laptop), Audio, Media controls (for Spotify)

---

### 2. ⌨️ Keyboard Shortcuts

**Philosophy:** Keep Super (Win/Mod4) as primary modifier.

#### Window Management
| Awesome WM | KDE Plasma Equivalent | Action |
|------------|----------------------|--------|
| `Super + Q` | `Super + Q` | Close window |
| `Super + Shift + C` | `Alt + F4` or `Super + Shift + C` | Close window (alternative) |
| `Super + F` | `Super + F` | Toggle fullscreen |
| `Super + M` | `Super + M` | Toggle maximize |
| `Super + Space` | Configure custom | Cycle layouts |
| `Super + Ctrl + Space` | Configure custom | Toggle floating |
| `Super + J` | `Super + J` | Focus next window |
| `Super + K` | `Super + K` | Focus previous window |
| `Super + Shift + J` | `Super + Shift + J` | Swap with next window |
| `Super + Shift + K` | `Super + Shift + K` | Swap with previous window |
| `Super + H` | `Super + H` | Shrink master width |
| `Super + L` | `Super + L` | Grow master width |
| `Super + Return` | `Super + Return` | Launch terminal (Kitty) |

**KDE Settings:** System Settings → Shortcuts → Global Shortcuts → KWin

#### Virtual Desktop (Workspace) Navigation
| Awesome WM | KDE Plasma | Action |
|------------|-----------|--------|
| `Super + 1/2/3/4` | `Super + 1/2/3/4` | Switch to desktop 1/2/3/4 |
| `Super + A` | `Super + A` | Previous desktop |
| `Super + D` | `Super + D` | Next desktop |
| `Super + Left` | `Super + Left` | Previous desktop |
| `Super + Right` | `Super + Right` | Next desktop |
| `Super + Shift + 1/2/3/4` | `Super + Shift + 1/2/3/4` | Move window to desktop 1/2/3/4 |
| `Super + Ctrl + 1/2/3/4` | Configure custom | Move window to desktop and follow |
| `Super + Ctrl + A/Left` | Configure custom | Move window to previous desktop and follow |
| `Super + Ctrl + D/Right` | Configure custom | Move window to next desktop and follow |

**Note:** Configure 4 virtual desktops in KDE (System Settings → Workspace Behavior → Virtual Desktops)

#### Monitor/Screen Switching
| Awesome WM | KDE Plasma | Action |
|------------|-----------|--------|
| `Super + Escape` | `Super + Escape` | Focus next screen |
| `Super + O` | Configure custom | Move window to other screen |

#### Application Launchers
| Awesome WM | KDE Plasma | Action |
|------------|-----------|--------|
| `Alt + Tab` | `Alt + Tab` | Window switcher (native KDE) |
| `Super + Z` | Keep Rofi or use KRunner | Window switcher (Rofi) |
| `Super + P` | Keep or use KRunner | Application launcher |
| `Super + R` | `Alt + Space` or `Alt + F2` | KRunner (KDE's launcher) |

**Decision:** Keep Rofi or migrate to KRunner?
- **Keep Rofi:** Consistent experience, OneDark theme already configured
- **Use KRunner:** Native KDE integration, more powerful plugins

#### Media Controls
| Awesome WM | KDE Plasma | Action |
|------------|-----------|--------|
| `XF86AudioMute` | ✓ Works by default | Toggle mute |
| `XF86AudioLowerVolume` | ✓ Works by default | Lower volume |
| `XF86AudioRaiseVolume` | ✓ Works by default | Raise volume |
| `XF86AudioPlay` | ✓ Works by default | Play/pause |
| `XF86AudioNext` | ✓ Works by default | Next track |
| `XF86AudioPrev` | ✓ Works by default | Previous track |
| `XF86MonBrightnessUp` | ✓ Works by default | Increase brightness |
| `XF86MonBrightnessDown` | ✓ Works by default | Decrease brightness |
| `Super + Shift + P` | Optional | Play/pause (alternative) |

#### System Controls
| Awesome WM | KDE Plasma | Action |
|------------|-----------|--------|
| `Super + Shift + Q` | Configure custom | Power menu |
| `Super + Ctrl + R` | `Ctrl + Alt + Esc` or custom | Reload/restart WM |

**Power Menu:** Can use KDE's native logout dialog or keep a custom rofi power menu.

---

### 3. 🪟 Window Management & Tiling

#### Tiling Options for KDE

**Option A: KDE Native Tiling (KWin)**
- Plasma 5.27+ has improved tiling support
- Enable in: System Settings → Window Management → Window Behavior → Window Tiling
- Pros: Native, no extra software
- Cons: Less customizable than dedicated tiling WM

**Option B: Krohnkite (KWin Script)**
- Install: `kpackagetool5 --type KWin/Script -i krohnkite`
- Provides proper dynamic tiling like Awesome
- Configure layouts: tile, monocle (max), etc.
- Pros: True tiling experience, very configurable
- Cons: Third-party script, occasional bugs

**Option C: Bismuth (KWin Script)**
- Similar to Krohnkite but more actively maintained
- Install from KDE Store or GitHub
- Pros: Active development, good tiling
- Cons: Learning curve for configuration

**Recommended:** Try **Bismuth** first, fallback to native KWin tiling if issues arise.

#### Window Rules
- [ ] Port Awesome WM rules to KDE Window Rules
- Location: System Settings → Window Management → Window Rules
- Configure specific applications (e.g., floating dialogs, specific desktop assignments)

**Awesome rules.lua insights:**
- Review `linux/awesome/rules.lua` for any custom window rules to replicate

---

### 4. 🖥️ Panel & Widgets

#### Top Panel Configuration
- [ ] Set panel to top (Awesome default)
- [ ] Adjust height: ~24-28px
- [ ] Background: OneDark background (`#21252b`)

#### Widgets to Add
1. **Application Launcher** - Similar to Awesome menu
2. **Task Manager** - Shows open windows (like tasklist)
3. **System Tray** - For systray icons
4. **Digital Clock** - With custom format if needed
5. **Audio Volume** - Plasma Audio Volume widget
6. **Battery Monitor** (Laptop only) - Replace Awesome battery widget
7. **Media Player** (Optional) - For Spotify integration (KDE Connect / Media Player widget)

**Custom Widgets:**
- Awesome had custom Lua widgets for battery, audio, Spotify
- KDE has native widgets that should cover most needs
- For Spotify: Consider "Media Player" widget or "Now Playing" from KDE Store

---

### 5. 🚀 Applications & Launchers

#### Terminal
- [x] Kitty already configured with OneDark theme
- [ ] Set as default terminal in KDE
- Location: System Settings → Applications → Default Applications → Terminal Emulator
- Command: `/home/olli/.local/kitty.app/bin/kitty`

#### Application Launcher
**Keep Rofi:**
- [x] Rofi already configured with OneDark theme
- [x] Config: `linux/rofi/config.rasi`
- [ ] Bind to `Super + Z` or desired key
- [ ] Keep `Alt + Tab` for window switching with Rofi

**Or Migrate to KRunner:**
- Native KDE launcher (Alt + Space / Alt + F2)
- Can be themed, has plugins for calculations, conversions, etc.
- [ ] Test KRunner and compare with Rofi experience

**Recommendation:** Keep both! Use Rofi for window switching and KRunner for quick commands/calculations.

---

### 6. ⌨️ Keyboard Settings

#### Keyboard Repeat Rate
**Current Awesome WM setting:** `xset r rate 200 35`
- Delay: 200ms (time before repeat starts)
- Rate: 35 characters/second (fast - optimized for gaming)

**KDE Configuration:**
- [ ] System Settings → Input Devices → Keyboard → Hardware tab
  - Repeat delay: ~200ms (adjust slider to match)
  - Repeat rate: Fast (~35 chars/sec - adjust slider to match)
- [ ] Test in a text editor to verify it feels right

**Alternative (if KDE settings don't stick):**
- Add to KDE autostart: `xset r rate 200 35`
- Create script: `~/.config/autostart-scripts/keyboard-settings.sh`

#### Keyboard Layout
- [ ] System Settings → Input Devices → Keyboard → Layouts
- [ ] Set your preferred layout(s)
- [ ] Configure layout switching shortcut if using multiple layouts

#### CapsLock → Escape Remapping
**Current Awesome WM setting:** `setxkbmap -option caps:escape`
- [ ] System Settings → Input Devices → Keyboard → Advanced tab
  - Enable "Caps Lock behavior"
  - Select "Make Caps Lock an additional Escape"
- Or check "Caps Lock is disabled" if you prefer

---

### 7. 🖱️ Mouse Settings

#### Mouse Sensitivity/Acceleration
**Current Awesome WM setting (Desktop):**
- `xinput --set-prop 12 'libinput Accel Speed' -0.3`
- Device ID: 12 (Logitech mouse)
- Acceleration: -0.3 (slightly slower than default)

**KDE Configuration:**
- [ ] System Settings → Input Devices → Mouse
  - Pointer speed: Adjust slider to match feel
  - Pointer acceleration: Try different profiles (Flat, Adaptive)
- [ ] Test in games/desktop to verify it feels right

**Note:** Device ID (12) may change. In KDE, settings apply to mouse by name/type automatically.

---

### 8. 🔐 Screen Locking & Power Management

#### Screen Locking
**Awesome WM Lock Script:**
- Current: `linux/awesome/lock.sh` (likely uses `i3lock` or similar)
- [ ] Review lock script to see what's being used
- [ ] KDE uses its own screen locker (KScreenLocker)
- [ ] Configure: System Settings → Workspace Behavior → Screen Locking
- [ ] Optional: Keep custom lock script and bind to shortcut if preferred

#### Power Management (DPMS)
**Current Awesome WM setting:**
- DPMS disabled: `xset -dpms`
- Screen saver disabled: `xset s off`
- Manually turn off screens: `xset dpms force off` (in power menu)

**KDE Configuration:**
- [ ] System Settings → Power Management → Energy Saving
  - Configure screen dimming/turn off timings
  - Or disable automatic screen power-off to match Awesome behavior
- [ ] System Settings → Power Management → Advanced Settings
  - Configure button events (lid close, power button)

**Note:** If you want to keep screens on indefinitely like in Awesome:
- Set "Turn off screen" to "Never" in Energy Saving settings
- Or add to autostart: `xset -dpms && xset s off`

---

### 7. 🖼️ Wallpapers

- [ ] Check if Awesome uses custom wallpaper
- [ ] Port wallpaper to KDE: System Settings → Appearance → Wallpaper
- Wallpapers location: `wallpapers/` in dotfiles

---

### 8. 🔧 Compositor & Effects

#### Compositor Settings
- Location: System Settings → Display and Monitor → Compositor
- [ ] Enable compositor (for effects, vsync)
- [ ] Disable if performance issues (especially on older hardware)
- [ ] Rendering backend: OpenGL 3.1 or higher (for NVIDIA RTX 4060 on desktop)

#### Window Effects
- [ ] Minimal effects for performance (like Awesome)
- [ ] Consider: Slide (for desktop switching), Fade (for window open/close)
- [ ] Disable: Wobbly windows, Magic Lamp, etc. (unless you like them!)

---

### 9. 📦 Additional Software

#### Required Packages
```bash
# Core KDE Plasma (already installed)
sudo apt install kde-plasma-desktop

# Tiling script (choose one)
# Bismuth (recommended)
sudo apt install kwin-bismuth  # if available in repos
# Or install from KDE Store

# Optional: Keep existing tools
# - Rofi (already installed)
# - Playerctl (for media controls)
# - Brightnessctl (for brightness controls)
```

#### Optional Enhancements
- **Latte Dock:** Fancy dock with lots of customization (if you want macOS-like dock)
- **Kvantum:** Theme engine for better Qt theming
- **KDE Store themes:** Search for "OneDark" themes for Plasma

---

### 10. 🗂️ Configuration Files

#### Files to Create/Manage
- [ ] `linux/kde/kwinrc` - KWin configuration
- [ ] `linux/kde/kdeglobals` - Global KDE settings
- [ ] `linux/kde/kglobalshortcutsrc` - Global shortcuts
- [ ] `linux/kde/plasma-org.kde.plasma.desktop-appletsrc` - Panel/widget configuration
- [ ] `linux/kde/restore_kde.sh` - Script to restore KDE settings
- [ ] `linux/kde/backup_kde.sh` - Script to backup current KDE settings

**Backup/Restore Scripts:**
Similar to `linux/awesome/restore_awesome.sh`, create scripts to:
- Backup KDE configs from `~/.config/` (kwinrc, kdeglobals, etc.)
- Restore configs from dotfiles repo
- Use `kwriteconfig5` or `kreadconfig5` for scriptable changes

---

### 11. 🎮 Gaming & NVIDIA

#### Desktop (RTX 4060)
- [x] Install NVIDIA proprietary drivers (via Linux Mint Driver Manager)
- [ ] Verify driver installation: `nvidia-smi`
- [ ] Enable "Force Composition Pipeline" in NVIDIA X Server Settings (to avoid tearing)
- [ ] KDE Compositor: Use OpenGL 3.1+ backend
- [ ] For gaming: Compositor auto-suspends during fullscreen games (good!)

#### Laptop (ThinkPad L470)
- Intel integrated graphics - should work perfectly
- No special configuration needed

---

### 12. 🔄 Workflow Adjustments

#### Things That Will Be Different
1. **No Lua scripting** - KDE uses QML/JavaScript for customization
2. **More GUI configuration** - Less text-based config than Awesome
3. **Heavier resource usage** - KDE is more feature-rich than Awesome
4. **Better out-of-box experience** - Less manual configuration needed

#### Things That Will Be Better
1. **GUI settings** - Easier to tweak without editing config files
2. **Native Wayland support** - KDE Plasma 6 has excellent Wayland support
3. **Better multi-monitor support** - KDE handles multiple displays well
4. **More widgets/plugins** - Huge KDE Store ecosystem
5. **Better application integration** - KDE apps integrate seamlessly

---

## 🚀 Quick Start Action Plan

### Phase 1: Initial Setup (Day 1)
1. [ ] Install KDE Plasma (✅ Done!)
2. [ ] Set 4 virtual desktops
3. [ ] Configure basic keyboard shortcuts (window management)
4. [ ] Set Kitty as default terminal
5. [ ] Configure fonts

### Phase 2: Theming (Day 1-2)
6. [ ] Find/install OneDark KDE color scheme
7. [ ] Configure panel (top, OneDark colors)
8. [ ] Add essential widgets to panel
9. [ ] Set window decoration style

### Phase 3: Tiling (Day 2)
10. [ ] Install Bismuth or enable KWin tiling
11. [ ] Configure tiling shortcuts
12. [ ] Test tiling layouts (tile, max)

### Phase 4: Advanced (Day 3+)
13. [ ] Port all keyboard shortcuts from Awesome
14. [ ] Configure window rules
15. [ ] Set up Rofi integration or switch to KRunner
16. [ ] Create backup/restore scripts
17. [ ] Fine-tune compositor settings for performance

---

## 📝 Notes

### Important Awesome WM Configs to Review
- `linux/awesome/rc.lua` - Main configuration
- `linux/awesome/keybindings.lua` - All keyboard shortcuts
- `linux/awesome/rules.lua` - Window rules
- `linux/awesome/themes/onedark.lua` - OneDark theme colors
- `linux/awesome/widgets/` - Custom widgets (battery, audio, spotify)

### Useful KDE Commands
```bash
# Restart KWin (window manager)
kwin_x11 --replace &  # X11
kwin_wayland --replace &  # Wayland

# Restart Plasma Shell (panel/widgets)
plasmashell --replace &

# List KWin scripts
kpackagetool5 --type KWin/Script --list

# Install KWin script
kpackagetool5 --type KWin/Script -i <script.kwinscript>

# Read KDE config value
kreadconfig5 --file kdeglobals --group General --key ColorScheme

# Write KDE config value
kwriteconfig5 --file kwinrc --group Windows --key FocusPolicy FocusFollowsMouse

# Backup KDE configs
tar -czf kde-config-backup.tar.gz ~/.config/plasma* ~/.config/kwin* ~/.config/kdeglobals

# Apply changes
qdbus org.kde.KWin /KWin reconfigure
```

---

## 🔗 Useful Resources

- [KDE Plasma Documentation](https://userbase.kde.org/Plasma)
- [Bismuth Tiling Script](https://github.com/Bismuth-Forge/bismuth)
- [Krohnkite Tiling Script](https://github.com/esjeon/krohnkite)
- [KDE Store](https://store.kde.org/) - Themes, widgets, scripts
- [KDE Shortcuts Configuration](https://userbase.kde.org/Plasma/Shortcuts)
- [Awesome WM Docs](https://awesomewm.org/doc/api/) - For reference during migration

---

## ✅ Success Criteria

Migration is complete when:
- [x] KDE Plasma installed and running
- [ ] OneDark theme applied (colors, fonts, decorations)
- [ ] All essential keyboard shortcuts working (window mgmt, desktops, apps)
- [ ] Tiling working (native or via script)
- [ ] Kitty terminal accessible and set as default
- [ ] Panel configured with widgets (clock, system tray, task manager, etc.)
- [ ] Multi-monitor setup working (if applicable)
- [ ] Backup/restore scripts created
- [ ] Comfortable workflow restored

---

**Good luck with your migration! 🎉**

Feel free to update this document as you discover new tweaks and configurations!

