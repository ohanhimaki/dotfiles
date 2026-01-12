using GlazeWM.Scripts.commands;

namespace Tests;

public class TestCommands
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public async Task DisplayAllInCurrent_shouldWork()
    {
        await DisplayAllInCurrentMonitor.RunAsync();
        Assert.Pass();

    }
    
    [Test]
    public async Task MinimizeAllExceptFocused_shouldWork()
    {
        await MinimizeAllExceptFocused.RunAsync();
        Assert.Pass();

    }
    [Test]
    public async Task FocusNextMinimized_shouldWork()
    {
        await FocusNextMinimized.RunAsync();
        Assert.Pass();

    }
}
