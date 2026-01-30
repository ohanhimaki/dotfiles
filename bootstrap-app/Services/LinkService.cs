using System.Runtime.InteropServices;
using Dotfiles.Models;

namespace Dotfiles.Services;

public class LinkService
{
    private readonly GlobalOptions _options;
    private readonly bool _isWindows;

    public LinkService(GlobalOptions options)
    {
        _options = options;
        _isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
    }

    public bool CreateSymlink(string source, string target, bool isDirectory)
    {
        Log($"  Starting With Parameters: {source} {target}", LogLevel.Warning);
        try
        {
            var targetDir = Path.GetDirectoryName(target);
            if (!string.IsNullOrEmpty(targetDir) && !Directory.Exists(targetDir))
            {
                Log($"  Creating directory: {targetDir}", LogLevel.Verbose);
                
                if (!_options.DryRun)
                {
                    Directory.CreateDirectory(targetDir);
                }
            }

if (File.Exists(target) || Directory.Exists(target))
{
    // Check if the existing item is a symbolic link (ReparsePoint)
    FileAttributes attributes = File.GetAttributes(target);
    bool isSymlink = attributes.HasFlag(FileAttributes.ReparsePoint);

    if (!isSymlink)
    {
        // It's a real file/folder. Rename it to keep a backup.
        string backupName = $"{target}_{DateTime.Now:yyyyMMddHHmmss}.bak";
        
        if (attributes.HasFlag(FileAttributes.Directory))
            Directory.Move(target, backupName);
        else
            File.Move(target, backupName);

        Log($"  ➔ Renamed existing item to: {Path.GetFileName(backupName)}");
    }
    /*
    else
    {
        // It's already a symlink. Delete it so we can create a fresh one.
        if (attributes.HasFlag(FileAttributes.Directory))
            Directory.Delete(target);
        else
            File.Delete(target);
            
        Log($"  ➔ Removed old symbolic link: {Path.GetFileName(target)}");
    }
*/
}

            if (!File.Exists(source) && !Directory.Exists(source))
            {
                Log($"  ⚠ Source not found: {source}", LogLevel.Warning);
                return false;
            }

            if (_options.DryRun)
            {
                Log($"  [DRY-RUN] Would link: {Path.GetFileName(target)} -> {source}", LogLevel.Verbose);
                Log($"  ✓ Link: {Path.GetFileName(target)} (dry-run)");
                return true;
            }

            if (_isWindows && isDirectory)
            {
                var psi = new System.Diagnostics.ProcessStartInfo("cmd", $"/c mklink /D \"{target}\" \"{source}\"")
                {
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };
                var proc = System.Diagnostics.Process.Start(psi);
                proc?.WaitForExit();
                
                if (proc?.ExitCode != 0)
                {
                    Log($"  ✗ Failed to create directory symlink", LogLevel.Warning);
                    return false;
                }
            }
            else
            {
                File.CreateSymbolicLink(target, source);
            }
            
            Log($"  ✓ Link: {Path.GetFileName(target)}");
            return true;
        }
        catch (Exception ex)
        {
            Log($"  ✗ Error: {ex.Message}", LogLevel.Warning);
            return false;
        }
    }

    public string ExpandPath(string path)
    {
        return path
            .Replace("{HOME}", Environment.GetFolderPath(Environment.SpecialFolder.UserProfile))
            .Replace("{APPDATA}", Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData))
            .Replace("{LOCALAPPDATA}", Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData))
            .Replace("{PROFILE}", GetPowerShellProfileDir());
    }

    public bool ShouldSkipLink(string unexpandedTarget)
    {
        var isLinux = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);

        // Skip Windows-specific paths on Linux
        if (isLinux && unexpandedTarget.Contains("{LOCALAPPDATA}")) return true;
        if (isLinux && unexpandedTarget.Contains("{APPDATA}")) return true;
        if (isLinux && unexpandedTarget.Contains("{PROFILE}")) return true;

        // Note: We don't skip {HOME}/.config on Windows because many cross-platform
        // tools (WezTerm, Neovim, Starship) use the same path on both platforms

        return false;
    }

    private string GetPowerShellProfileDir()
    {
        var docs = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
        return Path.Combine(docs, "PowerShell");
    }

    private void Log(string message, LogLevel level = LogLevel.Info)
    {
        if (level == LogLevel.Verbose && !_options.Verbose)
            return;
            
        Console.WriteLine(message);
    }

    private enum LogLevel
    {
        Info,
        Warning,
        Verbose
    }
}
