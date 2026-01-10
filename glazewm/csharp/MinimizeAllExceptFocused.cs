using System.Text.Json;

namespace GlazeWM.Scripts;

public static class MinimizeAllExceptFocused
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
        var windows = new List<JsonElement>();
        string? focusedWindowId = null;

        // Find all visible windows and the focused one
        foreach (var child in children.EnumerateArray())
        {
            if (child.TryGetProperty("state", out var state))
            {
                var stateType = state.GetProperty("type").GetString();
                if (stateType != "minimized")
                {
                    windows.Add(child);
                    if (child.GetProperty("hasFocus").GetBoolean())
                    {
                        focusedWindowId = child.GetProperty("id").GetString();
                        var appId = child.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";
                        Console.WriteLine($"Keeping focused window: {focusedWindowId} ({appId})");
                    }
                }
            }
        }

        Console.WriteLine($"Found {windows.Count} visible windows in focused workspace.");

        if (focusedWindowId == null)
        {
            Console.WriteLine("No focused window found");
            return 0;
        }

        // Minimize all windows except the focused one
        foreach (var window in windows)
        {
            var windowId = window.GetProperty("id").GetString();
            if (windowId != focusedWindowId)
            {
                var appId = window.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";
                Console.WriteLine($"Minimizing window: {windowId} ({appId})");

                await client.SendCommandAsync("focus", windowId);
                await Task.Delay(50);
                await client.SendCommandAsync("toggle-minimized");
                await Task.Delay(50);
            }
        }

        // Restore focus to the original window
        await client.SendCommandAsync("focus", focusedWindowId);

        Console.WriteLine("Done minimizing all except focused window.");
        await Task.Delay(100);
        return 0;
    }
}

