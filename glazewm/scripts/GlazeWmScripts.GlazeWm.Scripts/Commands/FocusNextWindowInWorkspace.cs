using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class FocusNextWindowInWorkspace
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      var workspace = await service.GetCurrentWorkspaceAsync();
      if (workspace == null)
      {
        Console.WriteLine("No current workspace found.");
        return 1;
      }

      var windows = workspace.Children;
      if (windows.Count == 0)
      {
        Console.WriteLine("No windows in the current workspace.");
        return 1;
      }

      var focusedWindowId = windows.FirstOrDefault(w => w.HasFocus)?.Id;

      var toBeFocusedIndex  = 0;
      if (focusedWindowId is null)
      {
        Console.WriteLine("No windows in the current workspace.");
      }
      else
      {
        var focusedWindowIdIndex = workspace.ChildFocusOrder.ToList().IndexOf(focusedWindowId);
        toBeFocusedIndex = (focusedWindowIdIndex + 1) % windows.Count;
      }
      var toBeFocusedId = workspace.ChildFocusOrder.ToList()[toBeFocusedIndex];
      await service.FocusWindowAsync(toBeFocusedId);

      return 0;
    }
  }
}
