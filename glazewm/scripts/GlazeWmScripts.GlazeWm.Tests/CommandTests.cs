using GlazeWmScripts.GlazeWm.Scripts;
using GlazeWmScripts.GlazeWm.Scripts.Commands;

namespace GlazeWmScripts.GlazeWm.Tests

{


  public class TestCommands
  {
    [SetUp]
    public async Task Setup()
    {
        var client = new GlazeWMClient();
        await client.ConnectAsync();
        service = new GlazeWMService(client);
    }

    public GlazeWMService service { get; set; }


    [Test]
    public async Task DisplayAllInCurrent_shouldWork()
    {
        await DisplayAllInCurrentMonitor.RunAsync(service);
        Assert.Pass();

    }
    //
    [Test]
    public async Task MinimizeAllExceptFocused_shouldWork()
    {
        await MinimizeAllExceptFocused.RunAsync(service);
        Assert.Pass();
    
    }
    [Test]
    public async Task FocusNextMinimized_shouldWork()
    {
        await FocusNextMinimized.RunAsync(service);
        Assert.Pass();
    
    }
    [Test]
    public async Task DisplayAllInCurrentCopy_shouldWork()
    {
        await DisplayAllInCurrentMonitorCopy.RunAsync(service);
        Assert.Pass();
    
    }
  }
}
