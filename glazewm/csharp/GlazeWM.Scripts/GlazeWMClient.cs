using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace GlazeWM.Scripts;

public class GlazeWMClient(string url = "ws://localhost:6123") : IDisposable
{
    private readonly ClientWebSocket _ws = new ();
    private readonly string _url = url;
    private int _messageId = 0;

    public async Task ConnectAsync(CancellationToken cancellationToken = default)
    {
        await _ws.ConnectAsync(new Uri(_url), cancellationToken);
        Console.WriteLine("Connected to GlazeWM IPC");
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
        
        Console.WriteLine($"Sending query: {queryType} with messageId: {messageId}");
        // var message = new
        // {
        //     messageId,
        //     messageType = "query",
        //     data = queryType
        // };

        var json = "query " + queryType;

        // var json = JsonSerializer.Serialize(message);
        var bytes = Encoding.UTF8.GetBytes(json);

        await _ws.SendAsync(new ArraySegment<byte>(bytes), WebSocketMessageType.Text, true, cancellationToken);

        return await ReceiveMessageAsync(cancellationToken);
    }

    private async Task<JsonDocument> ReceiveMessageAsync(CancellationToken cancellationToken = default)
    {
        var buffer = new byte[8192];
        var result = await _ws.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);

        var json = Encoding.UTF8.GetString(buffer, 0, result.Count);
        return JsonDocument.Parse(json);
    }

    public void Dispose()
    {
        _ws?.Dispose();
    }
}

