using Dotfiles.Services;

namespace Dotfiles.Installers;

public class ChocolateyInstallCommand : IInstallCommand
{
    private readonly string _package;
    private readonly string _args;
    private readonly InstallService _installService;

    public ChocolateyInstallCommand(string package, string args, InstallService installService)
    {
        _package = package;
        _args = args;
        _installService = installService;
    }

    public bool Execute()
    {
        return _installService.ChocolateyInstall(_package, _args);
    }

    public string GetDescription() => $"choco: {_package}";
}
