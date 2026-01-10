using System.Text.Json;

namespace GlazeWM.Scripts;

public static class FocusNextMinimized
{
    public static async Task<int> RunAsync()
    {
        using var client = new GlazeWMClient();
        await client.ConnectAsync();

        // Query workspaces
        var workspacesResponse = await client.QueryWorkspacesAsync();
        var workspaces = workspacesResponse.RootElement.GetProperty("data").GetProperty("workspaces");

        // Find focused workspace
        JsonElement? focusedWorkspace = null;
        foreach (var workspace in workspaces.EnumerateArray())
        {
            if (workspace.GetProperty("hasFocus").GetBoolean())
            {
                focusedWorkspace = workspace;
                break;
            }
        }

        if (focusedWorkspace == null)
        {
            Console.WriteLine("No focused workspace found");
            return 0;
        }

        var children = focusedWorkspace.Value.GetProperty("children");
        var minimizedWindows = new List<JsonElement>();

        // Find all minimized windows
        foreach (var child in children.EnumerateArray())
        {
            if (child.TryGetProperty("state", out var state))
            {
                var stateType = state.GetProperty("type").GetString();
                if (stateType == "minimized")
                {
                    minimizedWindows.Add(child);
                }
            }
        }

        Console.WriteLine($"Found {minimizedWindows.Count} minimized windows in focused workspace.");

        if (minimizedWindows.Count == 0)
        {
            Console.WriteLine("No minimized windows to focus");
            return 0;
        }

        // Focus the first minimized window
        var nextWindow = minimizedWindows[0];
        var windowId = nextWindow.GetProperty("id").GetString();
        var appId = nextWindow.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";

        Console.WriteLine($"Focusing minimized window: {windowId} ({appId})");
        await client.SendCommandAsync("focus", windowId);

        Console.WriteLine("Focused minimized window. You can now toggle-minimize it with Alt+M");
        await Task.Delay(100);
        return 0;
    }
}

