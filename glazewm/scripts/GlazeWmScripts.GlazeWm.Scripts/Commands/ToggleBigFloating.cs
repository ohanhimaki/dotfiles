using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts.Commands
{
  public class ToggleBigFloating
  {

    public static async Task<int> RunAsync(GlazeWMService service)
    {

      // Query monitors
      var window = await service.GetFocusedAsync();

      var monitors = await service.GetMonitorsAsync();
      var monitor = monitors.First(m => m.HasFocus);

      var isTiling = window.State.Type == "tiling";

      var height = monitor.Height - GlazeWmConsts.FullScreenHeightOffset * monitor.ScaleFactor;
      var width = monitor.Width-GlazeWmConsts.FullScreenWidthOffset * monitor.ScaleFactor;

      if (isTiling)
      {
        // Change to Floathing 
        // Change size to fullscreen 
        // change position to center
         await service.SendCommandAsync("set-floating");
         // await service.SendCommandAsync("size --width 1920 --height 1020");
          await service.SendCommandAsync($"size --width {width} --height {height}");
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


