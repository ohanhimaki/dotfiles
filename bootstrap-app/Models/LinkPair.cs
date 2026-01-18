namespace Dotfiles.Models;

public class LinkPair
{
    public string Source { get; set; } = "";
    public string Target { get; set; } = "";
    public bool IsDirectory { get; set; }

    public static LinkPair File(string source, string target) 
        => new() { Source = source, Target = target, IsDirectory = false };
    
    public static LinkPair Dir(string source, string target) 
        => new() { Source = source, Target = target, IsDirectory = true };
}
