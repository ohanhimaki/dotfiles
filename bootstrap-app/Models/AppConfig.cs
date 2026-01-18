using Dotfiles.Installers;

namespace Dotfiles.Models;

public class AppConfig
{
    public string Name { get; set; } = "";
    public string Description { get; set; } = "";
    public int MinLevel { get; set; } = 1;
    public List<string> Tags { get; set; } = new();
    public IInstallCommand? WindowsInstall { get; set; }
    public IInstallCommand? LinuxInstall { get; set; }
    public List<LinkPair> Links { get; set; } = new();
    public bool Enabled { get; set; } = true;
}
