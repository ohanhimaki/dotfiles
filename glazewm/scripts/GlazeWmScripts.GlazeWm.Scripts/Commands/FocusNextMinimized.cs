using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands;
public static class FocusNextMinimized
{
    public static async Task<int> RunAsync(GlazeWMService service)
    {

        // Query workspaces
        var workspacesResponse = await service.QueryWorkspacesAsync();
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

        var minimizedWindows = WorkspaceChildExtensions
            .FlattenWindowElements(focusedWorkspace.Value)
            .Where(w => w.TryGetProperty("state", out var s) && s.GetProperty("type").GetString() == "minimized")
            .ToList();

        Logger.Log($"Found {minimizedWindows.Count} minimized windows in focused workspace.");

        if (minimizedWindows.Count == 0)
        {
            Logger.Log("No minimized windows to focus");
            return 0;
        }

        // Focus the first minimized window
        var nextWindow = minimizedWindows[0];
        var windowId = nextWindow.GetProperty("id").GetString();
        var appId = nextWindow.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";

        Logger.Log($"Focusing minimized window: {windowId} ({appId})");
        await service.SendCommandAsync("focus", windowId);

        Logger.Log("Focused minimized window. You can now toggle-minimize it with Alt+M");
        return 0;
    }
}
