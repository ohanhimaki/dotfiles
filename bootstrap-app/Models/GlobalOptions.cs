namespace Dotfiles.Models;

public class GlobalOptions
{
    public bool Verbose { get; set; }
    public bool DryRun { get; set; }
    public string DotfilesPath { get; set; } = "";
}
