using System.Diagnostics;
using System.Text.Json;

public class GlazeWMCliClient
{
    // Suoritetaan komento (esim. "focus --next")
    public async Task SendCommandAsync(string command, string? containerId = null)
    {
        string args = containerId != null 
            ? $"command \"{command}\" --container-id {containerId}" 
            : $"command \"{command}\"";
            
        await RunCliAsync(args);
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
}
