using System.Runtime.InteropServices;
using Dotfiles.Models;
using Dotfiles.Services;

namespace Dotfiles.Commands;

public class ListCommand
{
    private readonly AppRepository _appRepository;
    private readonly GlobalOptions _options;

    public ListCommand(AppRepository appRepository, GlobalOptions options)
    {
        _appRepository = appRepository;
        _options = options;
    }

    public int Execute(string? filter = null)
    {
        var apps = _appRepository.GetAllApps();
        var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
        var isLinux = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);

        if (!string.IsNullOrWhiteSpace(filter))
        {
            apps = apps.Where(a => 
                a.Name.Contains(filter, StringComparison.OrdinalIgnoreCase) ||
                a.Description.Contains(filter, StringComparison.OrdinalIgnoreCase) ||
                a.Tags.Any(t => t.Contains(filter, StringComparison.OrdinalIgnoreCase))
            ).ToList();
        }

        Console.WriteLine("╔════════════════════════════════════════╗");
        Console.WriteLine("║          Available Applications         ║");
        Console.WriteLine("╚════════════════════════════════════════╝\n");

        foreach (var app in apps)
        {
            var hasInstall = (isWindows && app.WindowsInstall != null) || (isLinux && app.LinuxInstall != null);
            var hasLinks = app.Links.Any();
            
            Console.WriteLine($"📦 {app.Name}");
            Console.WriteLine($"   {app.Description}");
            Console.WriteLine($"   Level: {app.MinLevel} | Tags: {string.Join(", ", app.Tags)}");
            
            if (_options.Verbose)
            {
                if (hasInstall)
                {
                    var install = isWindows ? app.WindowsInstall : app.LinuxInstall;
                    Console.WriteLine($"   Install: {install?.GetDescription()}");
                }
                if (hasLinks)
                {
                    Console.WriteLine($"   Links: {app.Links.Count}");
                    foreach (var link in app.Links.Take(3))
                    {
                        Console.WriteLine($"     • {link.Source} → {link.Target}");
                    }
                    if (app.Links.Count > 3)
                    {
                        Console.WriteLine($"     ... and {app.Links.Count - 3} more");
                    }
                }
            }
            
            Console.WriteLine();
        }

        Console.WriteLine($"Total: {apps.Count} application(s)");
        
        return 0;
    }
}
