using System.Text.Json;

namespace GlazeWmScripts.GlazeWm.Scripts;

public interface IGlazeWMClient
{
    Task ConnectAsync(CancellationToken cancellationToken = default);
    Task<JsonDocument> SendCommandAsync(string command, string? containerId = null, CancellationToken cancellationToken = default);
    // Task<JsonDocument> QueryMonitorsAsync(CancellationToken cancellationToken = default);
    // Task<List<Models.Monitor>> GetMonitorsAsync(CancellationToken cancellationToken = default);
    Task<JsonDocument> QueryAsync(string queryType,CancellationToken cancellationToken = default);
    // Task<JsonDocument> QueryWorkspacesAsync(CancellationToken cancellationToken = default);
    // Task<JsonDocument> QueryWindowsAsync(CancellationToken cancellationToken = default);
    void Dispose();
}