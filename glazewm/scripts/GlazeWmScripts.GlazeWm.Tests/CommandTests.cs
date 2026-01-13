using GlazeWmScripts.GlazeWm.Scripts.Commands;

namespace GlazeWmScripts.GlazeWm.Tests

{


  public class TestCommands
  {
    [SetUp]
    public void Setup()
    {
        client = new GlazeWMCliClient();
    }

    public GlazeWMCliClient client { get; set; }

    [Test]
    public async Task DisplayAllInCurrent_shouldWork()
    {
        await DisplayAllInCurrentMonitor.RunAsync(client);
        Assert.Pass();

    }
    //
    [Test]
    public async Task MinimizeAllExceptFocused_shouldWork()
    {
        await MinimizeAllExceptFocused.RunAsync(client);
        Assert.Pass();
    
    }
    [Test]
    public async Task FocusNextMinimized_shouldWork()
    {
        await FocusNextMinimized.RunAsync(client);
        Assert.Pass();
    
    }
  }
}
