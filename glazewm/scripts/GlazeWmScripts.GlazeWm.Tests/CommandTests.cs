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
        _service = new GlazeWMService(client);
    }

    private GlazeWMService _service;


    [Test]
    public async Task DisplayAllInCurrent_shouldWork()
    {
        await DisplayAllInCurrentMonitor.RunAsync(_service);
        Assert.Pass();

    }
    //
    [Test]
    public async Task MinimizeAllExceptFocused_shouldWork()
    {
        await MinimizeAllExceptFocused.RunAsync(_service);
        Assert.Pass();
    
    }
    [Test]
    public async Task FocusNextMinimized_shouldWork()
    {
        await FocusNextMinimized.RunAsync(_service);
        Assert.Pass();
    
    }
    [Test]
    public async Task DisplayAllInCurrentCopy_shouldWork()
    {
        await DisplayAllInCurrentMonitorCopy.RunAsync(_service);
        Assert.Pass();
    
    }
    [Test]
    public async Task FocusNextWindowInWorkspace_shouldWork()
    {
        await FocusWindowInWorkspace.RunAsync(_service);
        Assert.Pass();
    
    }
    [Test]
    public async Task FocusWindowInWorkspace_shouldWork_prev()
    {
        await FocusWindowInWorkspace.RunAsync(_service,true);
        Assert.Pass();
    
    }
  }
}
