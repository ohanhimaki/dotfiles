using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class ToggleBigFloating
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      // Query monitors
      var window = await service.GetFocusedAsync();

      var isTiling = window.State.Type == "tiling";

      if (isTiling)
      {
        // Change to Floathing 
        // Change size to fullscreen 
        // change position to center
         await service.SendCommandAsync("set-floating");
         await service.SendCommandAsync("size --width 1920 --height 1020");
         await service.SendCommandAsync("position --centered");

      } else
      {
        // Change to Tiling
        await service.SendCommandAsync("set-tiling");

      }


      

      return 0;
    }
  }
}


