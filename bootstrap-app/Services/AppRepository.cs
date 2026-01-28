using Dotfiles.Installers;
using Dotfiles.Models;

namespace Dotfiles.Services;

public class AppRepository
{
    private readonly InstallService _installService;

    public AppRepository(InstallService installService)
    {
        _installService = installService;
    }

    public List<AppConfig> GetAllApps() => new List<AppConfig>
        {
            new AppConfig
            {
                Name = "Git",
                Description = "Version control",
                MinLevel = 1,
                Tags = ["essential", "dev"],
                WindowsInstall = new WingetInstallCommand("Git.Git", "", _installService),
                LinuxInstall = new AptInstallCommand("git", "", _installService),
            },

            new AppConfig
            {
                Name = "PowerShell Profile",
                Description = "PowerShell configuration and aliases",
                MinLevel = 1,
                Tags = new() { "shell", "windows" },
                WindowsInstall = new ManualInstallCommand("Built into Windows"),
                Links = new()
                {
                    LinkPair.File("powershell/Microsoft.PowerShell_profile.ps1", "{PROFILE}/Microsoft.PowerShell_profile.ps1"),
                    LinkPair.File("powershell/aliases.ps1", "{PROFILE}/aliases.ps1"),
                }
            },

            new AppConfig
            {
                Name = "WezTerm",
                Description = "GPU-accelerated terminal emulator",
                MinLevel = 1,
                Tags = new() { "terminal" },
                WindowsInstall = new WingetInstallCommand("wez.wezterm", "", _installService),
                LinuxInstall = new CustomInstallCommand(() => {
                    Console.WriteLine("  Install manually from: https://wezfurlong.org/wezterm/installation.html");
                    return true;
                }, "Manual install"),
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
                WindowsInstall = new WingetInstallCommand("glazewm.glazewm", "", _installService),
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
                WindowsInstall = new ChocolateyInstallCommand("powertoys", "", _installService),
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
                WindowsInstall = new ManualInstallCommand("Pre-installed on Windows 11"),
                Links = new()
                {
                    LinkPair.File("windowsterminal/settings.json", "{LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"),
                }
            },

            new AppConfig
            {
                Name = "Starship",
                Description = "Cross-shell prompt",
                MinLevel = 10,
                Tags = new() { "shell" },
                WindowsInstall = new WingetInstallCommand("Starship.Starship", "", _installService),
                LinuxInstall = new CustomInstallCommand(() => {
                    var psi = new System.Diagnostics.ProcessStartInfo("sh", "-c \"$(curl -fsSL https://starship.rs/install.sh)\"")
                    {
                        UseShellExecute = false,
                        CreateNoWindow = true
                    };
                    var proc = System.Diagnostics.Process.Start(psi);
                    proc?.WaitForExit();
                    return proc?.ExitCode == 0;
                }, "curl install"),
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
                WindowsInstall = new WingetInstallCommand("Neovim.Neovim", "", _installService),
                LinuxInstall = new AptInstallCommand("neovim", "", _installService),
                Links = new()
                {
                    LinkPair.Dir("nvim", "{LOCALAPPDATA}/nvim"),
                    LinkPair.Dir("nvim", "{HOME}/.config/nvim"),
                }
            },

            new AppConfig
            {
                Name = "Lazygit",
                Description = "Terminal UI for git",
                MinLevel = 10,
                Tags = new() { "git", "tui" },
                WindowsInstall = new WingetInstallCommand("JesseDuffield.lazygit", "", _installService),
                LinuxInstall = new AptInstallCommand("lazygit", "", _installService),
                Links = new()
                {
                    LinkPair.File("lazygit/config.yml", "{APPDATA}/lazygit/config.yml"),
                    LinkPair.File("lazygit/config.yml", "{HOME}/.config/lazygit/config.yml"),
                }
            },

            new AppConfig
            {
                Name = "Modern CLI Tools",
                Description = "ripgrep, fd, bat, eza, fzf, zoxide",
                MinLevel = 10,
                Tags = new() { "cli", "tools" },
                WindowsInstall = new CustomInstallCommand(() => {
                    _installService.WingetInstall("BurntSushi.ripgrep.MSVC");
                    _installService.WingetInstall("sharkdp.fd");
                    _installService.WingetInstall("sharkdp.bat");
                    _installService.WingetInstall("eza-community.eza");
                    _installService.WingetInstall("junegunn.fzf");
                    _installService.WingetInstall("ajeetdsouza.zoxide");
                    return true;
                }, "Multiple winget installs"),
                LinuxInstall = new CustomInstallCommand(() => {
                    _installService.AptInstall("ripgrep");
                    _installService.AptInstall("fd-find");
                    _installService.AptInstall("bat");
                    _installService.AptInstall("fzf");
                    return true;
                }, "Multiple apt installs"),
            },

            new AppConfig
            {
                Name = "VS Code",
                Description = "Visual Studio Code editor",
                MinLevel = 10,
                Tags = new() { "editor", "dev" },
                WindowsInstall = new WingetInstallCommand("Microsoft.VisualStudioCode", "", _installService),
                LinuxInstall = new AptInstallCommand("code", "", _installService),
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
                LinuxInstall = new ManualInstallCommand("Pre-installed"),
                Links = new()
                {
                    LinkPair.File("bash/.bashrc", "{HOME}/.bashrc"),
                    LinkPair.File("bash/.bash_profile", "{HOME}/.bash_profile"),
                }
            },

            new AppConfig
            {
                Name = "Zsh",
                Enabled = false,
                Description = "Z shell configuration",
                MinLevel = 10,
                Tags = new() { "shell", "linux" },
                LinuxInstall = new AptInstallCommand("zsh", "", _installService),
                Links = new()
                {
                    LinkPair.File("zsh/.zshrc", "{HOME}/.zshrc"),
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
                Name = "Entertainment",
                Description = "Spotify, VLC, Discord",
                MinLevel = 100,
                Tags = new() { "media" },
                WindowsInstall = new CustomInstallCommand(() => {
                    _installService.WingetInstall("VideoLAN.VLC");
                    _installService.WingetInstall("Spotify.Spotify");
                    _installService.WingetInstall("Discord.Discord");
                    return true;
                }, "Multiple choco installs"),
            },
            new AppConfig
            {
              Name = "Python",
              Description = "Python programming language",
              MinLevel = 10,
              Tags = new() { "dev", "language" },
              WindowsInstall = new WingetInstallCommand("Python.Python.3.14", "", _installService),
              LinuxInstall = new AptInstallCommand("python3", "", _installService),
            }
        };

    public AppConfig? GetAppByName(string name)
    {
        return GetAllApps().FirstOrDefault(a => 
            a.Name.Equals(name, StringComparison.OrdinalIgnoreCase));
    }
}
