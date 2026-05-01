using GlazeWmScripts.GlazeWm.Scripts;

namespace GlazeWmScripts.GlazeWm.Tests
{
  public class ClientTests
  {
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public async Task DebugQueryMonitors()
    {

      var client = new GlazeWMClient();

      await client.ConnectAsync();
      var result = await client.QueryMonitorsAsync();
      Assert.Pass();

    }
    [Test]
    public async Task GetMonitorsShouldReturn()
    {

      var client = new GlazeWMClient();

      await client.ConnectAsync();
      var result = await client.GetMonitorsAsync();

      foreach (GlazeWmScripts.GlazeWm.Scripts.Models.Monitor item in result)
      {
        Console.WriteLine($"Monitor ID: {item.Children}, Width: {item.Width}, Height: {item.Height}");

        foreach (var workspace in item.Children)
        {
          Console.WriteLine($"  Workspace ID: {workspace.Id}, Name: {workspace.DisplayName}");

          foreach (var window in workspace.Children.GetAllWindows())
          {
            Console.WriteLine($"    Window ID: {window.Id}, Title: {window.Title}");
          }
        }

      }




    }
  }
}
