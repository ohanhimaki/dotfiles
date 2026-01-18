namespace Dotfiles.Installers;

public interface IInstallCommand
{
    bool Execute();
    string GetDescription();
}
