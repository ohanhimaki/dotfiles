using Dotfiles.Services;

namespace Dotfiles.Installers;

public class AptInstallCommand : IInstallCommand
{
    private readonly string _package;
    private readonly string _args;
    private readonly InstallService _installService;

    public AptInstallCommand(string package, string args, InstallService installService)
    {
        _package = package;
        _args = args;
        _installService = installService;
    }

    public bool Execute()
    {
        return _installService.AptInstall(_package, _args);
    }

    public string GetDescription() => $"apt: {_package}";
}
