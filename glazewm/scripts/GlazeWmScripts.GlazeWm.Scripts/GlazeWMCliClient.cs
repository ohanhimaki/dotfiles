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
    public async Task<JsonDocument> QueryAsync(string queryType, CancellationToken cancellationToken = default)
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


    public Task ConnectAsync(CancellationToken cancellationToken = default)
    {
        // no need to connect in CLI client
        return Task.CompletedTask;
    }


    public void Dispose()
    {
        // No resources to dispose
        
    }
}
