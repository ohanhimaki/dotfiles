using System.Text.Json.Serialization;
using GlazeWmScripts.GlazeWm.Scripts.Models;

namespace GlazeWmScripts.GlazeWm.Scripts
{
    [JsonSerializable(typeof(Models.Monitor))]
    [JsonSerializable(typeof(Models.Workspace))]
    [JsonSerializable(typeof(Models.Window))]
    [JsonSerializable(typeof(Models.MonitorsResponse))]
    [JsonSerializable(typeof(Models.Data))]
    [JsonSourceGenerationOptions(WriteIndented = true)]
    public partial class JsonContext : JsonSerializerContext
    {
    }
}

