using GlazeWmScripts.GlazeWm.Scripts;

namespace GlazeWmScripts.GlazeWm.Tests
{
  public class CliClientTests
  {
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public async Task DebugQueryMonitors()
    {

      var client = new GlazeWMCliClient();

      var json = await client.QueryAsync("monitors");
      Console.WriteLine(json.RootElement.ToString());

      Assert.Pass();

    }
    [Test]
    public async Task GetMonitorsShouldReturn()
    {

      var client = new GlazeWMCliClient();
      var service = new GlazeWMService(client);

      var result = await service.GetMonitorsAsync();

      foreach (GlazeWmScripts.GlazeWm.Scripts.Models.Monitor item in result)
      {
        Console.WriteLine($"Monitor ID: {item.Children}, Width: {item.Width}, Height: {item.Height}");

        foreach (var workspace in item.Children)
        {
          Console.WriteLine($"  Workspace ID: {workspace.Id}, Name: {workspace.DisplayName}");

          foreach (var window in workspace.Children)
          {
            Console.WriteLine($"    Window ID: {window.Id}, Title: {window.Title}");
          }
        }

      }
      }
      [Test]
      public async Task GetWorkspacesShouldReturn()
      {

        var client = new GlazeWMCliClient();
        var service = new GlazeWMService(client);

        var workspaces = await service.GetWorkspacesAsync();

        
        foreach (var workspace in workspaces)
        {
          Console.WriteLine($"Workspace ID: {workspace.Id}, Name: {workspace.DisplayName}");
          foreach (var workspaceChild in workspace.Children)
          {
            Console.WriteLine($"  Child ID: {workspaceChild.Id}, Title: {workspaceChild.Title}");
            
          }
          
          foreach (var se in workspace.ChildFocusOrder)
          {
            
            Console.WriteLine($"  Focus Order Child ID: {se}");
          }
        }
        Assert.Pass();




    }
  }
}
