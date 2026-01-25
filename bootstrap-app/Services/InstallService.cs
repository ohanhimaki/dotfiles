using System.Diagnostics;
using System.Runtime.InteropServices;
using Dotfiles.Models;

namespace Dotfiles.Services;

public class InstallService
{
  private readonly GlobalOptions _options;
  private readonly bool _isWindows;

  public InstallService(GlobalOptions options)
  {
    _options = options;
    _isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
  }

  public bool WingetInstall(string package, string args = "")
  {
    if (!HasCommand("winget"))
    {
      Log($"  ⚠ Winget not available", LogLevel.Warning);
      return false;
    }

    Log($"  Installing via winget: {package}");

    if (_options.DryRun)
    {
      Log($"  [DRY-RUN] Would run: winget install --id {package} -e --silent", LogLevel.Verbose);
      return true;
    }

    var silent = _options.Verbose ? "" : "--silent";
    return RunCommand("winget", $"install --id {package} -e --accept-source-agreements --accept-package-agreements {silent} {args}");
  }

  public bool ChocolateyInstall(string package, string args = "")
  {
    if (!HasCommand("choco"))
    {
      Log($"  ⚠ Chocolatey not available", LogLevel.Warning);
      return false;
    }

    Log($"  Installing via choco: {package}");

    if (_options.DryRun)
    {
      Log($"  [DRY-RUN] Would run: choco install {package} -y", LogLevel.Verbose);
      return true;
    }

    return RunCommand("choco", $"install {package} -y {args}");
  }

  public bool AptInstall(string package, string args = "")
  {
    Log($"  Installing via apt: {package}");

    if (_options.DryRun)
    {
      Log($"  [DRY-RUN] Would run: apt-get install -y {package}", LogLevel.Verbose);
      return true;
    }

    return RunCommand("sudo", $"apt-get install -y {package} {args}");
  }

  public bool InstallChocolatey()
  {
    if (HasCommand("choco"))
    {
      Log("  Chocolatey already installed", LogLevel.Verbose);
      return true;
    }

    Console.WriteLine("═══ Installing Chocolatey ═══");

    if (_options.DryRun)
    {
      Log("  [DRY-RUN] Would install Chocolatey", LogLevel.Verbose);
      return true;
    }

    var script = @"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))";
    return RunCommand("powershell", $"-NoProfile -ExecutionPolicy Bypass -Command \"{script}\"");
  }

  public bool HasCommand(string command)
  {
    try
    {
      var proc = _isWindows
          ? Process.Start(new ProcessStartInfo("where", command) { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, CreateNoWindow = true })
          : Process.Start(new ProcessStartInfo("which", command) { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false, CreateNoWindow = true });
      proc?.WaitForExit();
      return proc?.ExitCode == 0;
    }
    catch
    {
      return false;
    }
  }

  private bool RunCommand(string command, string args)
  {
    Log($"  [EXEC] {command} {args}", LogLevel.Verbose);

    try
    {
      var psi = new ProcessStartInfo
      {
        FileName = command,
        Arguments = args,
        UseShellExecute = false,
        RedirectStandardOutput = true,
        RedirectStandardError = true,
        CreateNoWindow = true
      };

      using var proc = Process.Start(psi);
      if (proc == null)
      {
        Log("  ✗ Failed to start process", LogLevel.Warning);
        return false;
      }

      // Luetaan ennen WaitForExit -> ei deadlockia
      var output = proc.StandardOutput.ReadToEnd();
      var error = proc.StandardError.ReadToEnd();

      proc.WaitForExit();

      if (proc.ExitCode != 0)
      {
        Log(output, LogLevel.Verbose);
        Log($"  ✗ Exit code {proc.ExitCode}", LogLevel.Warning);
        if (!string.IsNullOrWhiteSpace(error))
          Log(error, LogLevel.Warning);
        return false;
      }

      return true;
    }
    catch (Exception ex)
    {
      Log($"  ✗ Exception: {ex}", LogLevel.Warning);
      return false;
    }
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
