using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands;
public static class MinimizeAllExceptFocused
{
    public static async Task<int> RunAsync(IGlazeWMClient client)
    {
        Logger.Log("Running MinimizeAllExceptFocused command");
        await client.ConnectAsync();
        Logger.Log("Connected to GlazeWM");

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
            Logger.Log("No focused workspace found");
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
                        Logger.Log($"Keeping focused window: {focusedWindowId} ({appId})");
                    }
                }
            }
        }

        Logger.Log($"Found {windows.Count} visible windows in focused workspace.");

        if (focusedWindowId == null)
        {
            Logger.Log("No focused window found");
            return 0;
        }

        // Minimize all windows except the focused one
        foreach (var window in windows)
        {
            var windowId = window.GetProperty("id").GetString();
            if (windowId != focusedWindowId)
            {
                var appId = window.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";
                Logger.Log($"Minimizing window: {windowId} ({appId})");

                await client.SendCommandAsync("focus", windowId);
                await client.SendCommandAsync("toggle-minimized");
            }
        }

        // Restore focus to the original window
        await client.SendCommandAsync("focus", focusedWindowId);

        Logger.Log("Done minimizing all except focused window.");
        return 0;
    }
}
