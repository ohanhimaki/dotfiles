using GlazeWmScripts.GlazeWm.Scripts;
using GlazeWmScripts.GlazeWm.Scripts.Commands;

Logger.Log("Starting");
var client = new GlazeWMClient();
await client.ConnectAsync();
var service = new GlazeWMService(client);
if (args.Length == 0)
{
    Logger.Log("Usage: GlazeWM.Scripts <command>");
    Logger.Log("Commands:");
    Logger.Log("  minimize-all-except-focused");
    Logger.Log("  focus-next-minimized");
    Logger.Log("  display-all-in-current-monitor");
    Logger.Log("  ");
    Logger.Log("Running default command: minimize-all-except-focused");
    await MinimizeAllExceptFocused.RunAsync(service);
    return 1;
}

var command = args[0];

try
{
    return command switch
    {
        "minimize-all-except-focused" => await MinimizeAllExceptFocused.RunAsync(service),
        "focus-next-minimized" => await FocusNextMinimized.RunAsync(service),
        "display-all-in-current-monitor" => await DisplayAllInCurrentMonitor.RunAsync(service),
        "focus-window-next" => await FocusWindowInWorkspace.RunAsync(service),
        "focus-window-prev" => await FocusWindowInWorkspace.RunAsync(service,true),
        _ => throw new ArgumentException($"Unknown command: {command}")
    };
}
catch (Exception ex)
{
    Logger.Log($"Error: {ex.Message}");
    return 1;
}

