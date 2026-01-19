using System.Text.Json;
using System.Diagnostics;
using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts;
using GlazeWmScripts.GlazeWm.Scripts.Models;
using Monitor = GlazeWmScripts.GlazeWm.Scripts.Models.Monitor;
using Focused = GlazeWmScripts.GlazeWm.Scripts.Models.Focused;

namespace GlazeWmScripts.GlazeWm.Scripts;

public class GlazeWMService
{
    private readonly IGlazeWMClient _client;

    public GlazeWMService(IGlazeWMClient client)
    {
        _client = client;
    }
    
    
    public async Task<List<Monitor>> GetMonitorsAsync(CancellationToken cancellationToken = default)
    {
        var json = await _client.QueryAsync("monitors");
        var monitors = json.RootElement.GetProperty("data").GetProperty("monitors");
        var result = new List<Monitor>();
        foreach (var monitor in monitors.EnumerateArray())
        {
            // Use source-generated JSON context for AOT compatibility
            var m = JsonSerializer.Deserialize(monitor.GetRawText(), JsonContext.Default.Monitor);
            if (m != null)
            {
                result.Add(m);
            }
        }

        return result.ToList();
    }
    public Task<JsonDocument> QueryMonitorsAsync(CancellationToken cancellationToken = default)
    {
        return _client.QueryAsync("monitors");
    }

    public async Task<List<Workspace>> GetWorkspacesAsync(CancellationToken cancellationToken = default)
    {
        var json = await _client.QueryAsync("workspaces");
        // cast json to WorkspaceResponse
        var workspaces = json.RootElement.GetProperty("data").GetProperty("workspaces");
        var result = new List<Workspace>();
        foreach (var workspace in workspaces.EnumerateArray())
        {
            // Use source-generated JSON context for AOT compatibility
            var w = JsonSerializer.Deserialize(workspace.GetRawText(), JsonContext.Default.Workspace);
            if (w != null)
            {
                result.Add(w);
            }
        }
        return result.ToList();


        
    }
    public Task<JsonDocument> QueryWorkspacesAsync(CancellationToken cancellationToken = default)
    {
        return _client.QueryAsync("workspaces");
    }

    public Task<JsonDocument> QueryWindowsAsync(CancellationToken cancellationToken = default)
    {
        return _client.QueryAsync("windows");
    }

    public async Task SendCommandAsync(string focus, string? container = null)
    {
        await _client.SendCommandAsync(focus, container);
    }

    public async Task<Workspace?> GetCurrentWorkspaceAsync()
    {
      var workspaces = await GetWorkspacesAsync();
      var currentWorkspace = workspaces.FirstOrDefault(w => w.HasFocus);
      return currentWorkspace;
    }

    public async Task FocusWindowAsync(string windowId)
    {
      await SendCommandAsync("focus", windowId);

    }

    internal async Task<Focused> GetFocusedAsync()
    {
      var response = await _client.QueryAsync("focused");
      var focused = JsonSerializer.Deserialize<FocusedResponse>(response.RootElement.GetRawText(),
          JsonContext.Default.FocusedResponse);
      return focused?.Data.Focused!;

    }
}
