using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class FocusWindowInWorkspace
  {

    public static async Task<int> RunAsync(GlazeWMService service, bool previous = false)
    {

      var workspace = await service.GetCurrentWorkspaceAsync();
      if (workspace == null)
      {
        Console.WriteLine("No current workspace found.");
        return 1;
      }

      var windows = workspace.Children.GetAllWindows().ToList();
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
        var focusedWindowIdIndex = windows.ToList().FindIndex(x => x.Id == focusedWindowId);

        if (previous)
        {
          toBeFocusedIndex = (focusedWindowIdIndex + windows.Count - 1) % windows.Count;
        }
        else
        {
          toBeFocusedIndex = (focusedWindowIdIndex + 1) % windows.Count;
        }
      }
      var toBeFocusedId = windows.ToList()[toBeFocusedIndex];
      await service.FocusWindowAsync(toBeFocusedId.Id);

      return 0;
    }
  }
  
}
