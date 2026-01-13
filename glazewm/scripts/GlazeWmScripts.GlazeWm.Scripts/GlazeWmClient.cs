using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts.Models;


namespace GlazeWmScripts.GlazeWm.Scripts
{
public class GlazeWMClient(string url = "ws://127.0.0.1:6123", bool waitForConnect = true) : IDisposable
{
    private readonly ClientWebSocket _ws = new ();
    private readonly string _url = url;
    private readonly bool _waitForConnect = waitForConnect;
    private int _messageId = 0;

    public async Task ConnectAsync(CancellationToken cancellationToken = default)
    {
        Logger.Log("Starting to connect to glazewm");
        _ws.Options.SetBuffer(8192 * 2, 8192 * 2);
        var call = _ws.ConnectAsync(new Uri(_url), cancellationToken);
        if (_waitForConnect)
        {
            Logger.Log("Waiting for GlazeWM to be available...");
            await call;
            Logger.Log("Connected to GlazeWM!");
            
        }
        else
        {
            Logger.Log("Hopefully GlazeWM is available...");
        }
        
    }

    public async Task<JsonDocument> SendCommandAsync(string command, string? containerId = null, CancellationToken cancellationToken = default)
    {
        var json = containerId != null
            ? $"command {command} --container-id {containerId}"
            : $"command {command}";
        
        var bytes = Encoding.UTF8.GetBytes(json);

        await _ws.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, cancellationToken);

        return await ReceiveMessageAsync(cancellationToken);
    }

    public async Task<JsonDocument> QueryMonitorsAsync(CancellationToken cancellationToken = default)
    {
        return await QueryAsync("monitors", cancellationToken);
    }

    public async Task<List<Models.Monitor>> GetMonitorsAsync(CancellationToken cancellationToken = default)
    {
        var json = await QueryAsync("monitors", cancellationToken);
        var monitors = json.RootElement.GetProperty("data").GetProperty("monitors");
        var result = new List<Models.Monitor>();
        foreach (var monitor in monitors.EnumerateArray())
        {
            // Use source-generated JSON context for AOT compatibility
            var m = JsonSerializer.Deserialize(monitor.GetRawText(), JsonContext.Default.Monitor);
            if (m != null)
            {
                result.Add(m);
            }
        }
        return result;

    }
    public async Task<JsonDocument> QueryWorkspacesAsync(CancellationToken cancellationToken = default)
    {
        return await QueryAsync("workspaces", cancellationToken);
    }

    public async Task<JsonDocument> QueryWindowsAsync(CancellationToken cancellationToken = default)
    {
        return await QueryAsync("windows", cancellationToken);
    }

    private async Task<JsonDocument> QueryAsync(string queryType, CancellationToken cancellationToken = default)
    {
        var messageId = Interlocked.Increment(ref _messageId).ToString();

        Logger.Log($"Sending query: {queryType} with messageId: {messageId}");

        var json = "query " + queryType;
        var bytes = Encoding.UTF8.GetBytes(json);

        await _ws.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, cancellationToken);

        return await ReceiveMessageAsync(cancellationToken);
    }

    private async Task<JsonDocument> ReceiveMessageAsync(CancellationToken cancellationToken = default)
    {
        var buffer = new byte[8192*2];
        var result = await _ws.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);

        var json = Encoding.UTF8.GetString(buffer, 0, result.Count);
        return JsonDocument.Parse(json);
    }

    public void Dispose()
    {
        _ws?.Dispose();
        GC.SuppressFinalize(this);
    }
}
}
