using System.Text.Json.Serialization;
using GlazeWmScripts.GlazeWm.Scripts.Models;

namespace GlazeWmScripts.GlazeWm.Scripts
{
    [JsonSerializable(typeof(Models.Monitor))]
    [JsonSerializable(typeof(Models.Workspace))]
    [JsonSerializable(typeof(Models.WorkspaceChild))]
    [JsonSerializable(typeof(Models.Window))]
    [JsonSerializable(typeof(Models.Split))]
    [JsonSerializable(typeof(Models.MonitorsResponse))]
    [JsonSerializable(typeof(Models.Data))]
    [JsonSerializable(typeof(Models.FocusedResponse))]
    [JsonSerializable(typeof(Models.Focused))]
    [JsonSerializable(typeof(Models.FocusedData))]
    [JsonSerializable(typeof(Models.WorkspacesResponse))]
    [JsonSerializable(typeof(Models.DataWorkspaces))]
    [JsonSerializable(typeof(Models.State))]
    [JsonSerializable(typeof(Models.Left))]
    // [JsonSerializable(typeof(JsonDocument))]
    [JsonSourceGenerationOptions(WriteIndented = true)]
    public partial class JsonContext : JsonSerializerContext
    {
    }
}

