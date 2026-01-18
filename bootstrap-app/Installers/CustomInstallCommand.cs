namespace Dotfiles.Installers;

public class CustomInstallCommand : IInstallCommand
{
    private readonly Func<bool> _installer;
    private readonly string _description;

    public CustomInstallCommand(Func<bool> installer, string description = "Custom installer")
    {
        _installer = installer;
        _description = description;
    }

    public bool Execute()
    {
        return _installer();
    }

    public string GetDescription() => _description;
}
