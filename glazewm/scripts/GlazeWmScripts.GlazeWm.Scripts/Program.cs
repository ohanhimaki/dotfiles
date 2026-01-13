using GlazeWmScripts.GlazeWm.Scripts;
using GlazeWmScripts.GlazeWm.Scripts.Commands;

Logger.Log("Starting");
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
    var client = new GlazeWMCliClient();
    return command switch
    {
        "minimize-all-except-focused" => await MinimizeAllExceptFocused.RunAsync(client),
        "focus-next-minimized" => await FocusNextMinimized.RunAsync(client),
        "display-all-in-current-monitor" => await DisplayAllInCurrentMonitor.RunAsync(client),
        _ => throw new ArgumentException($"Unknown command: {command}")
    };
}
catch (Exception ex)
{
    Logger.Log($"Error: {ex.Message}");
    return 1;
}

