namespace Dotfiles.Models;

public class BootstrapConfig
{
    public string GitProfile { get; set; } = "home";
    public int Level { get; set; } = 10;
    public List<string> EnabledApps { get; set; } = new();
}
