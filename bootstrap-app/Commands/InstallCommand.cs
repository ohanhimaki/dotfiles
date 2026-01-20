using System.Runtime.InteropServices;
using Dotfiles.Models;
using Dotfiles.Services;

namespace Dotfiles.Commands;

public class InstallCommand
{
    private readonly AppRepository _appRepository;
    private readonly InstallService _installService;
    private readonly LinkService _linkService;
    private readonly GlobalOptions _options;

    public InstallCommand(
        AppRepository appRepository, 
        InstallService installService,
        LinkService linkService,
        GlobalOptions options)
    {
        _appRepository = appRepository;
        _installService = installService;
        _linkService = linkService;
        _options = options;
    }

    public int Execute(string appName)
    {
        var app = _appRepository.GetAppByName(appName);
        if (app == null)
        {
            Console.WriteLine($"❌ Application '{appName}' not found.");
            Console.WriteLine($"Run 'dotfiles list' to see available applications.");
            return 1;
        }

        var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
        var isLinux = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);

        Console.WriteLine($"\n═══ Installing {app.Name} ═══");
        Console.WriteLine($"{app.Description}\n");

        // Install
        var installCmd = isWindows ? app.WindowsInstall : app.LinuxInstall;
        if (installCmd != null)
        {
            if (_options.Verbose)
            {
                Console.WriteLine($"Installing via: {installCmd.GetDescription()}");
            }
            
            installCmd.Execute();
        }
        else
        {
            Console.WriteLine($"  ℹ No installer available for {(isWindows ? "Windows" : "Linux")}");
        }

        // Create symlinks
        if (app.Links.Any())
        {
            Console.WriteLine($"\n═══ Creating Symlinks ═══");

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

        Console.WriteLine($"\n✅ {app.Name} installation complete!");
        return 0;
    }
}
