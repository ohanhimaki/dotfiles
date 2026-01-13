using System.Diagnostics;
using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts;
using Monitor = GlazeWmScripts.GlazeWm.Scripts.Models.Monitor;

public class GlazeWMCliClient : IGlazeWMClient
{
    // Suoritetaan komento (esim. "focus --next")
    public async Task<JsonDocument> SendCommandAsync(string command, string? containerId = null, CancellationToken cancellationToken = default)
    {
        string args = containerId != null 
            ? $"command \"{command}\" --container-id {containerId}" 
            : $"command \"{command}\"";
            
        var output = await RunCliAsync(args);
        return JsonDocument.Parse(output);
    }

    // Tehdään kysely (esim. "query windows")
    public async Task<JsonDocument> QueryAsync(string queryType)
    {
        string output = await RunCliAsync($"query {queryType}");
        return JsonDocument.Parse(output);
    }

    private async Task<string> RunCliAsync(string arguments)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = "glazewm.exe", // Varmista että tämä on PATH:ssa
            Arguments = arguments,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(startInfo);
        return await process.StandardOutput.ReadToEndAsync();
    }

    public async Task<List<Monitor>> GetMonitorsAsync(CancellationToken cancellationToken = default)
    {
        var json = await QueryAsync("monitors");
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

    public Task ConnectAsync(CancellationToken cancellationToken = default)
    {
        // no need to connect in CLI client
        return Task.CompletedTask;
    }

    public Task<JsonDocument> QueryMonitorsAsync(CancellationToken cancellationToken = default)
    {
        return QueryAsync("monitors");
    }

    public Task<JsonDocument> QueryWorkspacesAsync(CancellationToken cancellationToken = default)
    {
        return QueryAsync("workspaces");
    }

    public Task<JsonDocument> QueryWindowsAsync(CancellationToken cancellationToken = default)
    {
        return QueryAsync("windows");
    }

    public void Dispose()
    {
        // No resources to dispose
        
    }
}
