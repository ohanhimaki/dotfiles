using System.Text.Json;
using System.Diagnostics;
using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts;
using Monitor = GlazeWmScripts.GlazeWm.Scripts.Models.Monitor;

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
}