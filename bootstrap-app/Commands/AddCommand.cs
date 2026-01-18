using Dotfiles.Models;
using Dotfiles.Services;

namespace Dotfiles.Commands;

public class AddCommand
{
    private readonly LinkService _linkService;
    private readonly GlobalOptions _options;

    public AddCommand(LinkService linkService, GlobalOptions options)
    {
        _linkService = linkService;
        _options = options;
    }

    public int Execute(string source, string targetRelativePath)
    {
        // Normalize paths
        source = Path.GetFullPath(source);
        var targetPath = Path.Combine(_options.DotfilesPath, targetRelativePath);

        Console.WriteLine("╔════════════════════════════════════════╗");
        Console.WriteLine("║     Adding Config to Dotfiles Repo     ║");
        Console.WriteLine("╚════════════════════════════════════════╝\n");

        // Validate source exists
        var isDirectory = Directory.Exists(source);
        var isFile = File.Exists(source);

        if (!isDirectory && !isFile)
        {
            Console.WriteLine($"❌ Source does not exist: {source}");
            return 1;
        }

        // Check if target already exists
        if (Directory.Exists(targetPath) || File.Exists(targetPath))
        {
            Console.WriteLine($"❌ Target already exists: {targetPath}");
            Console.WriteLine("Remove it first or choose a different target path.");
            return 1;
        }

        Console.WriteLine($"Source:      {source}");
        Console.WriteLine($"Target:      {targetPath}");
        Console.WriteLine($"Type:        {(isDirectory ? "Directory" : "File")}");
        Console.WriteLine();

        if (_options.DryRun)
        {
            Console.WriteLine("[DRY-RUN] Would perform the following:");
            Console.WriteLine($"  1. Copy {(isDirectory ? "directory" : "file")} to dotfiles repo");
            Console.WriteLine($"  2. Create symlink from original location back to dotfiles");
            return 0;
        }

        try
        {
            // Create target directory if needed
            var targetDir = Path.GetDirectoryName(targetPath);
            if (!string.IsNullOrEmpty(targetDir) && !Directory.Exists(targetDir))
            {
                if (_options.Verbose)
                {
                    Console.WriteLine($"Creating directory: {targetDir}");
                }
                Directory.CreateDirectory(targetDir);
            }

            // Copy to dotfiles repo
            Console.WriteLine("📋 Copying to dotfiles repository...");
            
            if (isDirectory)
            {
                CopyDirectory(source, targetPath);
            }
            else
            {
                File.Copy(source, targetPath);
            }

            Console.WriteLine($"  ✓ Copied to {targetPath}");

            // Backup original
            var backupPath = source + ".backup";
            if (File.Exists(backupPath) || Directory.Exists(backupPath))
            {
                Console.WriteLine($"⚠ Backup already exists: {backupPath}");
                Console.WriteLine("Skipping backup creation.");
            }
            else
            {
                Console.WriteLine($"💾 Creating backup: {backupPath}");
                if (isDirectory)
                {
                    CopyDirectory(source, backupPath);
                }
                else
                {
                    File.Copy(source, backupPath);
                }
                Console.WriteLine("  ✓ Backup created");
            }

            // Remove original
            Console.WriteLine($"🗑️  Removing original...");
            if (isDirectory)
            {
                Directory.Delete(source, true);
            }
            else
            {
                File.Delete(source);
            }
            Console.WriteLine("  ✓ Original removed");

            // Create shadowlink back
            Console.WriteLine($"🔗 Creating symlink from original location to dotfiles...");
            _linkService.CreateSymlink(targetPath, source, isDirectory);

            Console.WriteLine("\n╔════════════════════════════════════════╗");
            Console.WriteLine("║              Success! 🎉                ║");
            Console.WriteLine("╚════════════════════════════════════════╝");
            Console.WriteLine($"\nYour config is now managed in: {targetPath}");
            Console.WriteLine($"And symlinked from: {source}");
            Console.WriteLine($"\nNext steps:");
            Console.WriteLine($"  • Add to AppRepository in Services/AppRepository.cs");
            Console.WriteLine($"  • Commit changes to git");
            
            return 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\n❌ Error: {ex.Message}");
            return 1;
        }
    }

    private void CopyDirectory(string sourceDir, string targetDir)
    {
        Directory.CreateDirectory(targetDir);

        foreach (var file in Directory.GetFiles(sourceDir))
        {
            var fileName = Path.GetFileName(file);
            var targetFile = Path.Combine(targetDir, fileName);
            File.Copy(file, targetFile);
            
            if (_options.Verbose)
            {
                Console.WriteLine($"  Copied: {fileName}");
            }
        }

        foreach (var dir in Directory.GetDirectories(sourceDir))
        {
            var dirName = Path.GetFileName(dir);
            var targetSubDir = Path.Combine(targetDir, dirName);
            CopyDirectory(dir, targetSubDir);
        }
    }
}
