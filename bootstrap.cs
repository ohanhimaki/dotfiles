#!/usr/bin/env dotnet script
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;

// ============================================================================
// Configuration Framework
// ============================================================================

enum InstallMethod
{
    Winget,
    Chocolatey,
    AptGet,
    Script,
    Manual
}

class InstallCommand
{
    public InstallMethod Method { get; set; }
    public string Package { get; set; }
    public string Args { get; set; }
    public Func<bool> CustomInstall { get; set; }

    public static InstallCommand Winget(string package, string args = "") 
        => new() { Method = InstallMethod.Winget, Package = package, Args = args };
    
    public static InstallCommand Choco(string package, string args = "") 
        => new() { Method = InstallMethod.Chocolatey, Package = package, Args = args };
    
    public static InstallCommand Apt(string package, string args = "") 
        => new() { Method = InstallMethod.AptGet, Package = package, Args = args };
    
    public static InstallCommand Custom(Func<bool> installer) 
        => new() { Method = InstallMethod.Script, CustomInstall = installer };
    
    public static InstallCommand Manual(string instructions) 
        => new() { Method = InstallMethod.Manual, Package = instructions };
}

class LinkPair
{
    public string Source { get; set; }  // Path in dotfiles repo
    public string Target { get; set; }  // Where to link it to
    public bool IsDirectory { get; set; }

    public static LinkPair File(string source, string target) 
        => new() { Source = source, Target = target, IsDirectory = false };
    
    public static LinkPair Dir(string source, string target) 
        => new() { Source = source, Target = target, IsDirectory = true };
}

class AppConfig
{
    public string Name { get; set; }
    public string Description { get; set; }
    public int MinLevel { get; set; } = 1;  // 1=Minimal, 10=Basic, 100=Full
    public List<string> Tags { get; set; } = new();
    public InstallCommand WindowsInstall { get; set; }
    public InstallCommand LinuxInstall { get; set; }
    public List<LinkPair> Links { get; set; } = new();
    public bool Enabled { get; set; } = true;
}

// ============================================================================
// App Configurations - ADD YOUR APPS HERE
// ============================================================================

var apps = new List<AppConfig>
{
    new AppConfig
    {
        Name = "Git",
        Description = "Version control",
        MinLevel = 1,
        Tags = new() { "essential", "dev" },
        WindowsInstall = InstallCommand.Winget("Git.Git"),
        LinuxInstall = InstallCommand.Apt("git"),
    },

    new AppConfig
    {
        Name = "PowerShell Profile",
        Description = "PowerShell configuration and aliases",
        MinLevel = 1,
        Tags = new() { "shell", "windows" },
        WindowsInstall = InstallCommand.Manual("Built into Windows"),
        Links = new()
        {
            LinkPair.File("powershell/Microsoft.PowerShell_profile.ps1", 
                         "{PROFILE}/Microsoft.PowerShell_profile.ps1"),
            LinkPair.File("powershell/aliases.ps1", 
                         "{PROFILE}/aliases.ps1"),
        }
    },

    new AppConfig
    {
        Name = "WezTerm",
        Description = "GPU-accelerated terminal emulator",
        MinLevel = 1,
        Tags = new() { "terminal" },
        WindowsInstall = InstallCommand.Winget("wez.wezterm"),
        LinuxInstall = InstallCommand.Custom(() => {
            Console.WriteLine("  Install manually from: https://wezfurlong.org/wezterm/installation.html");
            return true;
        }),
        Links = new()
        {
            LinkPair.Dir("wezterm", "{HOME}/.config/wezterm"),
        }
    },

    new AppConfig
    {
        Name = "GlazeWM",
        Description = "Tiling window manager for Windows",
        MinLevel = 1,
        Tags = new() { "wm", "windows" },
        WindowsInstall = InstallCommand.Winget("glazewm.glazewm"),
        Links = new()
        {
            LinkPair.File("glazewm/config.yaml", "{HOME}/.glzr/glazewm/config.yaml"),
            LinkPair.File("glazewm/zebar/settings.json", "{HOME}/.glzr/zebar/settings.json"),
            LinkPair.Dir("glazewm/zebar/glzr-io.starter@0.0.0", "{HOME}/.glzr/zebar/glzr-io.starter@0.0.0"),
        }
    },

    new AppConfig
    {
        Name = "PowerToys",
        Description = "Windows utilities",
        MinLevel = 1,
        Tags = new() { "utilities", "windows" },
        WindowsInstall = InstallCommand.Choco("powertoys"),
        Links = new()
        {
            LinkPair.File("powertoys/settings.json", "{LOCALAPPDATA}/Microsoft/PowerToys/settings.json"),
            LinkPair.File("powertoys/fancyzones/settings.json", "{LOCALAPPDATA}/Microsoft/PowerToys/fancyzones/settings.json"),
            LinkPair.File("powertoys/fancyzones/zones-settings.json", "{LOCALAPPDATA}/Microsoft/PowerToys/fancyzones/zones-settings.json"),
        }
    },

    new AppConfig
    {
        Name = "Windows Terminal",
        Description = "Modern terminal for Windows",
        MinLevel = 1,
        Tags = new() { "terminal", "windows" },
        WindowsInstall = InstallCommand.Manual("Pre-installed on Windows 11"),
        Links = new()
        {
            LinkPair.File("windowsterminal/settings.json", 
                         "{LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"),
        }
    },

    new AppConfig
    {
        Name = "Starship",
        Description = "Cross-shell prompt",
        MinLevel = 10,
        Tags = new() { "shell" },
        WindowsInstall = InstallCommand.Winget("Starship.Starship"),
        LinuxInstall = InstallCommand.Custom(() => {
            return RunCommand("sh", "-c \"$(curl -fsSL https://starship.rs/install.sh)\"");
        }),
        Links = new()
        {
            LinkPair.File("starship/starship.toml", "{HOME}/.config/starship.toml"),
        }
    },

    new AppConfig
    {
        Name = "Neovim",
        Description = "Hyperextensible Vim-based text editor",
        MinLevel = 10,
        Tags = new() { "editor", "dev" },
        WindowsInstall = InstallCommand.Winget("Neovim.Neovim"),
        LinuxInstall = InstallCommand.Apt("neovim"),
        Links = new()
        {
            LinkPair.Dir("nvim", "{LOCALAPPDATA}/nvim"),  // Windows
            LinkPair.Dir("nvim", "{HOME}/.config/nvim"),  // Linux
        }
    },

    new AppConfig
    {
        Name = "Lazygit",
        Description = "Terminal UI for git",
        MinLevel = 10,
        Tags = new() { "git", "tui" },
        WindowsInstall = InstallCommand.Winget("JesseDuffield.lazygit"),
        LinuxInstall = InstallCommand.Apt("lazygit"),
        Links = new()
        {
            LinkPair.File("lazygit/config.yml", "{APPDATA}/lazygit/config.yml"),     // Windows
            LinkPair.File("lazygit/config.yml", "{HOME}/.config/lazygit/config.yml"), // Linux
        }
    },

    new AppConfig
    {
        Name = "Modern CLI Tools",
        Description = "ripgrep, fd, bat, eza, fzf, zoxide",
        MinLevel = 10,
        Tags = new() { "cli", "tools" },
        WindowsInstall = InstallCommand.Custom(() => {
            WingetInstall("BurntSushi.ripgrep.MSVC");
            WingetInstall("sharkdp.fd");
            WingetInstall("sharkdp.bat");
            WingetInstall("eza-community.eza");
            WingetInstall("junegunn.fzf");
            WingetInstall("ajeetdsouza.zoxide");
            return true;
        }),
        LinuxInstall = InstallCommand.Custom(() => {
            AptInstall("ripgrep");
            AptInstall("fd-find");
            AptInstall("bat");
            AptInstall("fzf");
            return true;
        }),
    },

    new AppConfig
    {
        Name = "VS Code",
        Description = "Visual Studio Code editor",
        MinLevel = 10,
        Tags = new() { "editor", "dev" },
        WindowsInstall = InstallCommand.Winget("Microsoft.VisualStudioCode"),
        LinuxInstall = InstallCommand.Apt("code"),
        Links = new()
        {
            LinkPair.File("vscode/settings.json", "{APPDATA}/Code/User/settings.json"),
            LinkPair.File("vscode/keybindings.json", "{APPDATA}/Code/User/keybindings.json"),
            LinkPair.File("vscode/settings.json", "{HOME}/.config/Code/User/settings.json"),
            LinkPair.File("vscode/keybindings.json", "{HOME}/.config/Code/User/keybindings.json"),
        }
    },

    new AppConfig
    {
        Name = "Bash",
        Description = "Bash shell configuration",
        MinLevel = 1,
        Tags = new() { "shell", "linux" },
        LinuxInstall = InstallCommand.Manual("Pre-installed"),
        Links = new()
        {
            LinkPair.File("bash/.bashrc", "{HOME}/.bashrc"),
            LinkPair.File("bash/.bash_profile", "{HOME}/.bash_profile"),
        }
    },

    new AppConfig
    {
        Name = "Zsh",
        Description = "Z shell configuration",
        MinLevel = 10,
        Tags = new() { "shell", "linux" },
        LinuxInstall = InstallCommand.Apt("zsh"),
        Links = new()
        {
            LinkPair.File("zsh/.zshrc", "{HOME}/.zshrc"),
        }
    },

    new AppConfig
    {
        Name = "Vim",
        Description = "Vi IMproved text editor",
        MinLevel = 1,
        Tags = new() { "editor", "linux" },
        LinuxInstall = InstallCommand.Apt("vim"),
        Links = new()
        {
            LinkPair.File("vim/.vimrc", "{HOME}/.vimrc"),
        }
    },

    new AppConfig
    {
        Name = "Rider/IDEA Vim",
        Description = "IdeaVim configuration",
        MinLevel = 100,
        Tags = new() { "ide", "vim" },
        Links = new()
        {
            LinkPair.File("idea/.ideavimrc", "{HOME}/.ideavimrc"),
        }
    },

    new AppConfig
    {
        Name = "Common Tools",
        Description = "7zip, Process Explorer, Fira Code",
        MinLevel = 10,
        Tags = new() { "utilities", "windows" },
        WindowsInstall = InstallCommand.Custom(() => {
            ChocolateyInstall("7zip");
            ChocolateyInstall("procexp");
            ChocolateyInstall("firacode");
            return true;
        }),
    },

    new AppConfig
    {
        Name = "Entertainment",
        Description = "Spotify, VLC, Discord",
        MinLevel = 100,
        Tags = new() { "media" },
        WindowsInstall = InstallCommand.Custom(() => {
            ChocolateyInstall("spotify");
            ChocolateyInstall("vlc");
            ChocolateyInstall("discord");
            return true;
        }),
    },
};

// ============================================================================
// Main Program
// ============================================================================

var dotfilesPath = Path.GetDirectoryName(Environment.ProcessPath) ?? Directory.GetCurrentDirectory();
var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
var isLinux = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);

Console.WriteLine("╔════════════════════════════════════════╗");
Console.WriteLine("║     Dotfiles Bootstrap Framework      ║");
Console.WriteLine("╚════════════════════════════════════════╝");
Console.WriteLine($"\nOS: {(isWindows ? "Windows" : isLinux ? "Linux" : "Unknown")}");
Console.WriteLine($"Path: {dotfilesPath}\n");

// Check prerequisites
if (!HasCommand("git"))
{
    Console.WriteLine("❌ ERROR: Git not found. Please install Git first.");
    Environment.Exit(1);
}

// Profile selection (work/home)
Console.WriteLine("═══ Git Profile ═══");
Console.WriteLine("1. Work");
Console.WriteLine("2. Home");
Console.Write("\nChoice [1-2]: ");
var profileChoice = Console.ReadLine();
var gitProfile = profileChoice == "1" ? "work" : "home";
Console.WriteLine($"Selected: {gitProfile}\n");

// Level selection
Console.WriteLine("═══ Installation Level ═══");
Console.WriteLine("1. Minimal  - Essential configs only");
Console.WriteLine("2. Basic    - Standard development setup (recommended)");
Console.WriteLine("3. Full     - Everything");
Console.Write("\nChoice [1-3]: ");
var levelChoice = Console.ReadLine();
var level = levelChoice switch {
    "1" => 1,
    "2" => 10,
    "3" => 100,
    _ => 10
};

// Filter apps by level and OS
var availableApps = apps.Where(a => a.MinLevel <= level).ToList();

// Show available apps
Console.WriteLine($"\n═══ Available Apps (Level: {level}) ═══");
for (int i = 0; i < availableApps.Count; i++)
{
    var app = availableApps[i];
    var hasInstall = (isWindows && app.WindowsInstall != null) || (isLinux && app.LinuxInstall != null);
    var hasLinks = app.Links.Any();
    var indicator = app.Enabled ? "☑" : "☐";
    
    Console.WriteLine($"{i + 1,2}. {indicator} {app.Name,-25} {app.Description}");
    Console.WriteLine($"     Tags: {string.Join(", ", app.Tags)}");
    if (hasInstall) Console.WriteLine($"     Install: ✓");
    if (hasLinks) Console.WriteLine($"     Links: {app.Links.Count}");
}

// Let user toggle apps
Console.WriteLine("\n═══ Customize Installation ═══");
Console.WriteLine("Enter app numbers to toggle (space-separated), or press Enter to continue:");
var toggleInput = Console.ReadLine();
if (!string.IsNullOrWhiteSpace(toggleInput))
{
    var indices = toggleInput.Split(' ', StringSplitOptions.RemoveEmptyEntries)
                             .Select(s => int.TryParse(s, out var n) ? n - 1 : -1)
                             .Where(i => i >= 0 && i < availableApps.Count);
    
    foreach (var idx in indices)
    {
        availableApps[idx].Enabled = !availableApps[idx].Enabled;
    }
}

// Confirm
Console.WriteLine("\n═══ Installation Summary ═══");
var enabledApps = availableApps.Where(a => a.Enabled).ToList();
Console.WriteLine($"Git Profile: {gitProfile}");
Console.WriteLine($"Apps to install: {enabledApps.Count}");
foreach (var app in enabledApps)
{
    Console.WriteLine($"  • {app.Name}");
}

Console.Write("\nProceed? [Y/n]: ");
if (Console.ReadLine()?.ToLower() == "n")
{
    Console.WriteLine("Cancelled.");
    Environment.Exit(0);
}

// ============================================================================
// Installation
// ============================================================================

Console.WriteLine("\n╔════════════════════════════════════════╗");
Console.WriteLine("║         Starting Installation          ║");
Console.WriteLine("╚════════════════════════════════════════╝\n");

// Install Chocolatey on Windows if needed
if (isWindows && enabledApps.Any(a => a.WindowsInstall?.Method == InstallMethod.Chocolatey))
{
    if (!HasCommand("choco"))
    {
        Console.WriteLine("═══ Installing Chocolatey ═══");
        RunPowerShell(@"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))");
    }
}

// Handle Git configuration
Console.WriteLine("═══ Configuring Git ═══");
var gitConfigSource = Path.Combine(dotfilesPath, "git", $".gitconfig-{gitProfile}");
var gitConfigTarget = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".gitconfig");

if (File.Exists(gitConfigSource))
{
    if (File.Exists(gitConfigTarget))
    {
        Console.WriteLine($"  Warning: {gitConfigTarget} already exists, skipping...");
    }
    else
    {
        File.Copy(gitConfigSource, gitConfigTarget);
        Console.WriteLine($"  ✓ Copied {gitProfile} git config");
    }
}
else
{
    Console.WriteLine($"  Warning: {gitConfigSource} not found");
}

// Install and link each app
foreach (var app in enabledApps)
{
    Console.WriteLine($"\n═══ {app.Name} ═══");
    
    // Install
    var installCmd = isWindows ? app.WindowsInstall : app.LinuxInstall;
    if (installCmd != null)
    {
        ExecuteInstall(installCmd);
    }
    
    // Create symlinks
    foreach (var link in app.Links)
    {
        var source = Path.Combine(dotfilesPath, link.Source);
        var target = ExpandPath(link.Target);
        
        // Skip OS-specific links
        if (isWindows && target.Contains("{HOME}/.config")) continue;
        if (isLinux && target.Contains("{LOCALAPPDATA}")) continue;
        if (isLinux && target.Contains("{APPDATA}")) continue;
        if (isLinux && target.Contains("{PROFILE}")) continue;
        
        CreateSymlink(source, target, link.IsDirectory);
    }
}

Console.WriteLine("\n╔════════════════════════════════════════╗");
Console.WriteLine("║       Installation Complete! 🎉        ║");
Console.WriteLine("╚════════════════════════════════════════╝");
Console.WriteLine("\nNext steps:");
Console.WriteLine("  • Restart your terminal");
Console.WriteLine("  • Configure Git username/email if needed");
Console.WriteLine("  • Check that symlinks are working correctly");

// ============================================================================
// Helper Functions
// ============================================================================

void ExecuteInstall(InstallCommand cmd)
{
    switch (cmd.Method)
    {
        case InstallMethod.Winget:
            WingetInstall(cmd.Package, cmd.Args);
            break;
        case InstallMethod.Chocolatey:
            ChocolateyInstall(cmd.Package, cmd.Args);
            break;
        case InstallMethod.AptGet:
            AptInstall(cmd.Package, cmd.Args);
            break;
        case InstallMethod.Script:
            if (cmd.CustomInstall != null)
            {
                cmd.CustomInstall();
            }
            break;
        case InstallMethod.Manual:
            Console.WriteLine($"  ℹ {cmd.Package}");
            break;
    }
}

void WingetInstall(string package, string args = "")
{
    if (HasCommand("winget"))
    {
        Console.WriteLine($"  Installing via winget: {package}");
        RunCommand("winget", $"install --id {package} -e --silent --accept-source-agreements --accept-package-agreements {args}");
    }
}

void ChocolateyInstall(string package, string args = "")
{
    if (HasCommand("choco"))
    {
        Console.WriteLine($"  Installing via choco: {package}");
        RunCommand("choco", $"install {package} -y {args}");
    }
}

void AptInstall(string package, string args = "")
{
    Console.WriteLine($"  Installing via apt: {package}");
    RunCommand("sudo", $"apt-get install -y {package} {args}");
}

void CreateSymlink(string source, string target, bool isDirectory)
{
    try
    {
        var targetDir = Path.GetDirectoryName(target);
        if (!string.IsNullOrEmpty(targetDir) && !Directory.Exists(targetDir))
        {
            Directory.CreateDirectory(targetDir);
        }

        if (File.Exists(target) || Directory.Exists(target))
        {
            Console.WriteLine($"  ⊘ Skip: {Path.GetFileName(target)} (exists)");
            return;
        }

        if (!File.Exists(source) && !Directory.Exists(source))
        {
            Console.WriteLine($"  ⚠ Source not found: {source}");
            return;
        }

        if (isWindows && isDirectory)
        {
            RunCommand("cmd", $"/c mklink /D \"{target}\" \"{source}\"");
        }
        else
        {
            File.CreateSymbolicLink(target, source);
        }
        
        Console.WriteLine($"  ✓ Link: {Path.GetFileName(target)}");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"  ✗ Error: {ex.Message}");
    }
}

string ExpandPath(string path)
{
    return path
        .Replace("{HOME}", Environment.GetFolderPath(Environment.SpecialFolder.UserProfile))
        .Replace("{APPDATA}", Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData))
        .Replace("{LOCALAPPDATA}", Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData))
        .Replace("{PROFILE}", GetPowerShellProfileDir());
}

string GetPowerShellProfileDir()
{
    var docs = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
    return Path.Combine(docs, "PowerShell");
}

bool HasCommand(string command)
{
    try
    {
        var proc = isWindows 
            ? Process.Start(new ProcessStartInfo("where", command) { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, CreateNoWindow = true })
            : Process.Start(new ProcessStartInfo("which", command) { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, CreateNoWindow = true });
        proc?.WaitForExit();
        return proc?.ExitCode == 0;
    }
    catch
    {
        return false;
    }
}

bool RunCommand(string command, string args)
{
    try
    {
        var proc = Process.Start(new ProcessStartInfo(command, args) 
        { 
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true
        });
        proc?.WaitForExit();
        return proc?.ExitCode == 0;
    }
    catch (Exception ex)
    {
        Console.WriteLine($"  ✗ Error: {ex.Message}");
        return false;
    }
}

void RunPowerShell(string script)
{
    RunCommand("powershell", $"-NoProfile -ExecutionPolicy Bypass -Command \"{script}\"");
}
