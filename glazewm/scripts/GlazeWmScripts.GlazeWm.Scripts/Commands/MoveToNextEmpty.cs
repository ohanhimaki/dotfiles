using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class MoveToNextEmpty
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      // Query monitors
      var window = await service.GetFocusedAsync();

      var workspaces = await service.GetWorkspacesAsync();
      var workspaceNames = workspaces.Select(m => m.Name);

      var allWorkspaces = GlazeWmConsts.WorkspaceNames;

      var emptyWorkspace = allWorkspaces
        .Where(w => !workspaceNames.Contains(w))
        .FirstOrDefault();




      await service.SendCommandAsync($"move --workspace {emptyWorkspace}");
      await service.SendCommandAsync($"focus --workspace {emptyWorkspace}");


      

      return 0;
    }
  }
}


