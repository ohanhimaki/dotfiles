using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class DisplayAllInCurrentMonitorCopy
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      // Query monitors
      var workspaces = await service.GetWorkspacesAsync();


      var focusedWorkspace = workspaces.FirstOrDefault(w => w.HasFocus);

      if (focusedWorkspace == null)
      {
        Logger.Log("No focused workspace found");
        return 0;
      }



      var allWindows = focusedWorkspace.Children.GetAllWindows().ToList();

      var focusedWindow = allWindows.FirstOrDefault(w => w.HasFocus);

      var minimizedWindows = allWindows.Where(x => x.State.Type == "minimized").ToList();

      Logger.Log($"Found {minimizedWindows.Count} hidden windows in focused workspace.");

      // Restore all minimized windows
      foreach (var window in minimizedWindows)
      {
        await service.SendCommandAsync("focus", window.Id);
        await service.SendCommandAsync("toggle-minimized");
      }

      if (focusedWindow != null)
      {
        await service.SendCommandAsync("focus", focusedWindow.Id);
      }
      return 0;
    }
  }
}
