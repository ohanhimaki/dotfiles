using System.Runtime.InteropServices;
using Dotfiles.Models;
using Dotfiles.Services;

namespace Dotfiles.Commands;

public class BootstrapCommand
{
    private readonly AppRepository _appRepository;
    private readonly InstallService _installService;
    private readonly LinkService _linkService;
    private readonly ConfigService _configService;
    private readonly GlobalOptions _options;

    public BootstrapCommand(
        AppRepository appRepository,
        InstallService installService,
        LinkService linkService,
        ConfigService configService,
        GlobalOptions options)
    {
        _appRepository = appRepository;
        _installService = installService;
        _linkService = linkService;
        _configService = configService;
        _options = options;
    }

    public int Execute(bool interactive = false)
    {
        var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
        var isLinux = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);

        Console.WriteLine("╔════════════════════════════════════════╗");
        Console.WriteLine("║     Dotfiles Bootstrap Framework      ║");
        Console.WriteLine("╚════════════════════════════════════════╝");
        Console.WriteLine($"\nOS: {(isWindows ? "Windows" : isLinux ? "Linux" : "Unknown")}");
        Console.WriteLine($"Path: {_options.DotfilesPath}");
        
        if (_options.DryRun)
        {
            Console.WriteLine($"Mode: DRY-RUN (no changes will be made)");
        }
        
        Console.WriteLine();

        // Check prerequisites
        if (!_installService.HasCommand("git"))
        {
            Console.WriteLine("❌ ERROR: Git not found. Please install Git first.");
            return 1;
        }

        // Try to load previous config
        BootstrapConfig? config = null;
        if (!interactive)
        {
            config = _configService.LoadConfig();
            if (config != null)
            {
                Console.WriteLine("✨ Found previous configuration:");
                Console.WriteLine($"   Git Profile: {config.GitProfile}");
                Console.WriteLine($"   Level: {config.Level}");
                Console.WriteLine($"   Apps: {config.EnabledApps.Count}");
                Console.Write("\nUse this configuration? [Y/n]: ");
                var use = Console.ReadLine();
                if (use?.ToLower() == "n")
                {
                    config = null;
                }
                else
                {
                    Console.WriteLine();
                }
            }
        }

        // Interactive selection if no config or forced interactive
        string gitProfile;
        int level;
        List<AppConfig> enabledApps;

        if (config == null)
        {
            // Profile selection
            Console.WriteLine("═══ Git Profile ═══");
            Console.WriteLine("1. Work");
            Console.WriteLine("2. Home");
            Console.Write("\nChoice [1-2]: ");
            var profileChoice = Console.ReadLine();
            gitProfile = profileChoice == "1" ? "work" : "home";
            Console.WriteLine($"Selected: {gitProfile}\n");

            // Level selection
            Console.WriteLine("═══ Installation Level ═══");
            Console.WriteLine("1. Minimal  - Essential configs only");
            Console.WriteLine("2. Basic    - Standard development setup (recommended)");
            Console.WriteLine("3. Full     - Everything");
            Console.Write("\nChoice [1-3]: ");
            var levelChoice = Console.ReadLine();
            level = levelChoice switch {
                "1" => 1,
                "2" => 10,
                "3" => 100,
                _ => 10
            };

            // Filter apps by level
            var availableApps = _appRepository.GetAllApps()
                .Where(a => a.MinLevel <= level)
                .ToList();

            // Show available apps
            Console.WriteLine($"\n═══ Available Apps (Level: {level}) ═══");
            for (int i = 0; i < availableApps.Count; i++)
            {
                var app = availableApps[i];
                var hasInstall = (isWindows && app.WindowsInstall != null) || (isLinux && app.LinuxInstall != null);
                var hasLinks = app.Links.Any();
                var indicator = app.Enabled ? "☑" : "☐";
                
                Console.WriteLine($"{i + 1,2}. {indicator} {app.Name,-25} {app.Description}");
                
                if (_options.Verbose)
                {
                    Console.WriteLine($"     Tags: {string.Join(", ", app.Tags)}");
                    if (hasInstall) Console.WriteLine($"     Install: ✓");
                    if (hasLinks) Console.WriteLine($"     Links: {app.Links.Count}");
                }
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

            enabledApps = availableApps.Where(a => a.Enabled).ToList();

            // Save config for next time
            var newConfig = new BootstrapConfig
            {
                GitProfile = gitProfile,
                Level = level,
                EnabledApps = enabledApps.Select(a => a.Name).ToList()
            };
            _configService.SaveConfig(newConfig);
        }
        else
        {
            // Use saved config
            gitProfile = config.GitProfile;
            level = config.Level;
            
            var allApps = _appRepository.GetAllApps();
            enabledApps = allApps
                .Where(a => config.EnabledApps.Contains(a.Name))
                .ToList();
        }

        // Confirm
        Console.WriteLine("\n═══ Installation Summary ═══");
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
            return 0;
        }

        // Start installation
        Console.WriteLine("\n╔════════════════════════════════════════╗");
        Console.WriteLine("║         Starting Installation          ║");
        Console.WriteLine("╚════════════════════════════════════════╝\n");

        // Install Chocolatey on Windows if needed
        if (isWindows && enabledApps.Any(a => a.WindowsInstall?.GetDescription().Contains("choco") == true))
        {
            if (!_installService.HasCommand("choco"))
            {
                _installService.InstallChocolatey();
            }
        }

        // Handle Git configuration
        Console.WriteLine("═══ Configuring Git ═══");
        var gitConfigSource = Path.Combine(_options.DotfilesPath, "git", $".gitconfig-{gitProfile}");
        var gitConfigTarget = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".gitconfig");

        if (File.Exists(gitConfigSource))
        {
            if (File.Exists(gitConfigTarget))
            {
                Console.WriteLine($"  Warning: {gitConfigTarget} already exists, skipping...");
            }
            else
            {
                if (_options.DryRun)
                {
                    Console.WriteLine($"  [DRY-RUN] Would copy: {gitConfigSource} → {gitConfigTarget}");
                }
                else
                {
                    File.Copy(gitConfigSource, gitConfigTarget);
                    Console.WriteLine($"  ✓ Copied {gitProfile} git config");
                }
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
                if (_options.Verbose)
                {
                    Console.WriteLine($"  Installer: {installCmd.GetDescription()}");
                }
                installCmd.Execute();
            }
            else
            {
                if (_options.Verbose)
                {
                    Console.WriteLine($"  No installer for this OS");
                }
            }
            
            // Create symlinks
            foreach (var link in app.Links)
            {
                // Check if this link should be skipped BEFORE expanding the path
                if (_linkService.ShouldSkipLink(link.Target))
                {
                    if (_options.Verbose)
                    {
                        Console.WriteLine($"  ⊘ Skipping OS-incompatible link: {link.Target}");
                    }
                    continue;
                }

                var source = Path.Combine(_options.DotfilesPath, link.Source);
                var target = _linkService.ExpandPath(link.Target);

                _linkService.CreateSymlink(source, target, link.IsDirectory);
            }
        }

        Console.WriteLine("\n╔════════════════════════════════════════╗");
        Console.WriteLine("║       Installation Complete! 🎉        ║");
        Console.WriteLine("╚════════════════════════════════════════╝");
        Console.WriteLine("\nNext steps:");
        Console.WriteLine("  • Restart your terminal");
        Console.WriteLine("  • Configure Git username/email if needed");
        Console.WriteLine("  • Check that symlinks are working correctly");

        return 0;
    }
}
