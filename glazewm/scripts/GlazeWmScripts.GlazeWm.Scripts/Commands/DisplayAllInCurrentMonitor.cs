using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class DisplayAllInCurrentMonitor
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      // Query monitors
      var monitorsResponse = await service.QueryMonitorsAsync();
      var monitors = monitorsResponse.RootElement.GetProperty("data").GetProperty("monitors");

      int monitorIndex = 0;
      int currentIndex = 0;
      foreach (var monitor in monitors.EnumerateArray())
      {
        if (monitor.GetProperty("hasFocus").GetBoolean())
        {
          monitorIndex = currentIndex;
          break;
        }
        currentIndex++;
      }

      Logger.Log($"Current monitor index: {monitorIndex}");

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

      Logger.Log($"Found {minimizedWindows.Count} hidden windows in focused workspace.");

      // Restore all minimized windows
      foreach (var window in minimizedWindows)
      {
        var windowId = window.GetProperty("id").GetString();
        var appId = window.TryGetProperty("appId", out var aid) ? aid.GetString() : "unknown";

        Logger.Log($"Restoring window: {windowId} ({appId})");
        await service.SendCommandAsync("focus", windowId);
        await service.SendCommandAsync("toggle-minimized");
      }

      return 0;
    }
  }
}
