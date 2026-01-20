using Dotfiles.Commands;
using Dotfiles.Models;
using Dotfiles.Services;

// Parse arguments
var arguments = Environment.GetCommandLineArgs().Skip(1).ToArray();

// Global options
var globalOptions = new GlobalOptions
{
    Verbose = arguments.Contains("--verbose") || arguments.Contains("-v"),
    DryRun = arguments.Contains("--dry-run") || arguments.Contains("-n"),
    DotfilesPath = GetDotfilesPath()
};

// Remove global flags from args
arguments = arguments.Where(a => !a.StartsWith("--verbose") && !a.StartsWith("-v") && 
                       !a.StartsWith("--dry-run") && !a.StartsWith("-n")).ToArray();

// Get command
var command = arguments.Length > 0 ? arguments[0].ToLower() : "help";

// Initialize services
var installService = new InstallService(globalOptions);
var linkService = new LinkService(globalOptions);
var appRepository = new AppRepository(installService);
var configService = new ConfigService(globalOptions.DotfilesPath);

// Execute command
try
{
    var exitCode = command switch
    {
        "bootstrap" => new BootstrapCommand(appRepository, installService, linkService, configService, globalOptions)
            .Execute(arguments.Contains("--interactive") || arguments.Contains("-i")),
        
        "list" => new ListCommand(appRepository, globalOptions)
            .Execute(arguments.Length > 1 ? arguments[1] : null),
        
        "install" => arguments.Length > 1 
            ? new InstallCommand(appRepository, installService, linkService, globalOptions)
                .Execute(arguments[1])
            : ShowInstallUsage(),
        
        "add" => arguments.Length > 2
            ? new AddCommand(linkService, globalOptions)
                .Execute(arguments[1], arguments[2])
            : ShowAddUsage(),
        
        "help" or "--help" or "-h" => ShowHelp(),
        
        _ => ShowHelp()
    };

    Environment.Exit(exitCode);
}
catch (Exception ex)
{
    Console.WriteLine($"\n❌ Unexpected error: {ex.Message}");
    if (globalOptions.Verbose)
    {
        Console.WriteLine(ex.StackTrace);
    }
    Environment.Exit(1);
}

string GetDotfilesPath()
{
    // Try to find dotfiles directory
    var currentDir = Directory.GetCurrentDirectory();
    
    // If we're in bootstrap-app, go up one level
    if (currentDir.EndsWith("bootstrap-app") )
    {
        return Path.GetFullPath(Path.Combine(currentDir, ".."));
    }
    
    if ( currentDir.EndsWith("bootstrap-app\\bin\\Debug\\net10.0"))
    {
        return Path.GetFullPath(Path.Combine(currentDir, "..", "..", ".."));
    }
    // Otherwise assume current directory
    return currentDir;
}

int ShowHelp()
{
    Console.WriteLine("╔════════════════════════════════════════╗");
    Console.WriteLine("║          Dotfiles Manager              ║");
    Console.WriteLine("╚════════════════════════════════════════╝");
    Console.WriteLine();
    Console.WriteLine("Usage: dotfiles <command> [options]");
    Console.WriteLine();
    Console.WriteLine("Commands:");
    Console.WriteLine("  bootstrap             Run full bootstrap setup");
    Console.WriteLine("    -i, --interactive   Force interactive mode (ignore cache)");
    Console.WriteLine();
    Console.WriteLine("  list [filter]         List all available applications");
    Console.WriteLine("                        Optional filter by name/tag/description");
    Console.WriteLine();
    Console.WriteLine("  install <name>        Install a specific application");
    Console.WriteLine();
    Console.WriteLine("  add <source> <target> Copy config to dotfiles and create shadowlink");
    Console.WriteLine("                        Example: dotfiles add ~/.config/nvim nvim");
    Console.WriteLine();
    Console.WriteLine("Global Options:");
    Console.WriteLine("  -v, --verbose         Show detailed output");
    Console.WriteLine("  -n, --dry-run         Show what would be done without doing it");
    Console.WriteLine("  -h, --help            Show this help");
    Console.WriteLine();
    Console.WriteLine("Examples:");
    Console.WriteLine("  dotfiles bootstrap");
    Console.WriteLine("  dotfiles bootstrap --interactive");
    Console.WriteLine("  dotfiles list");
    Console.WriteLine("  dotfiles list terminal");
    Console.WriteLine("  dotfiles install neovim");
    Console.WriteLine("  dotfiles add ~/.config/nvim nvim/");
    Console.WriteLine("  dotfiles bootstrap --dry-run --verbose");
    Console.WriteLine();
    return 0;
}

int ShowInstallUsage()
{
    Console.WriteLine("Usage: dotfiles install <app-name>");
    Console.WriteLine();
    Console.WriteLine("Examples:");
    Console.WriteLine("  dotfiles install neovim");
    Console.WriteLine("  dotfiles install \"Modern CLI Tools\"");
    Console.WriteLine();
    Console.WriteLine("Run 'dotfiles list' to see available applications.");
    return 1;
}

int ShowAddUsage()
{
    Console.WriteLine("Usage: dotfiles add <source> <target>");
    Console.WriteLine();
    Console.WriteLine("Arguments:");
    Console.WriteLine("  source  Path to existing config file or directory");
    Console.WriteLine("  target  Relative path in dotfiles repo (e.g., nvim/)");
    Console.WriteLine();
    Console.WriteLine("Examples:");
    Console.WriteLine("  dotfiles add ~/.config/nvim nvim/");
    Console.WriteLine("  dotfiles add ~/.vimrc vim/.vimrc");
    Console.WriteLine();
    return 1;
}
