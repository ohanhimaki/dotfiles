using GlazeWM.Scripts;

namespace Tests;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public async Task debugQueryMonitors()
    {

        var client = new GlazeWM.Scripts.GlazeWMClient();

        await client.ConnectAsync();
        var result = await client.QueryMonitorsAsync();

// get the result as a formatted ToString
        var resultString = result.RootElement.GetRawText();


        Console.WriteLine(resultString);
        Assert.Pass();

    }
    [Test]
    public async Task DisplayAllInCurrent_shouldWork()
    {
        await DisplayAllInCurrentMonitor.RunAsync();
        Assert.Pass();

    }
}
