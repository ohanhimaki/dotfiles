using GlazeWM.Scripts;
using GlazeWM.Scripts.commands;

if (args.Length == 0)
{
    Logger.Log("Usage: GlazeWM.Scripts <command>");
    Logger.Log("Commands:");
    Logger.Log("  minimize-all-except-focused");
    Logger.Log("  focus-next-minimized");
    Logger.Log("  display-all-in-current-monitor");
    return 1;
}

var command = args[0];

try
{
    return command switch
    {
        "minimize-all-except-focused" => await MinimizeAllExceptFocused.RunAsync(),
        "focus-next-minimized" => await FocusNextMinimized.RunAsync(),
        "display-all-in-current-monitor" => await DisplayAllInCurrentMonitor.RunAsync(),
        _ => throw new ArgumentException($"Unknown command: {command}")
    };
}
catch (Exception ex)
{
    Logger.Log($"Error: {ex.Message}");
    return 1;
}

