namespace Tests;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public async Task Test1()
    {

        var client = new GlazeWM.Scripts.GlazeWMClient();

        var result = await client.QueryMonitorsAsync();

        Console.WriteLine(result.ToString());
        Assert.Pass();

    }
}
