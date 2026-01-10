using GlazeWM.Scripts;

if (args.Length == 0)
{
    Console.WriteLine("Usage: GlazeWM.Scripts <command>");
    Console.WriteLine("Commands:");
    Console.WriteLine("  minimize-all-except-focused");
    Console.WriteLine("  focus-next-minimized");
    Console.WriteLine("  display-all-in-current-monitor");
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
    Console.WriteLine($"Error: {ex.Message}");
    return 1;
}

