using System.Runtime.InteropServices;
using Dotfiles.Installers;
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
        List<InstallErrors> errors = new();
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
            
            var result = installCmd.Execute();
            if (!result)
            {
                Console.WriteLine($"❌ Installation failed for {app.Name}.");
                //aadd to errors
                errors.Add(new InstallErrors(installCmd));
            }
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

        if (errors.Count > 0)
        {
            Console.WriteLine($"\n❌ Installation completed with errors for {app.Name}:");
            foreach (var error in errors)
            {
                Console.WriteLine($" - {error.TypeName}: {error.Description}");
            }
            return 1;
        } 
        else {
          Console.WriteLine($"\n✅ {app.Name} installation complete!");
        }
        return 0;
    }
}

internal class InstallErrors
{

    public InstallErrors(IInstallCommand installCmd)
    {
      // typeofinstallcmd
      TypeName = installCmd.GetType().Name;
      Description = installCmd.GetDescription();

    }

    public string TypeName { get; private set; }
    public string Description { get; private set; }
}
