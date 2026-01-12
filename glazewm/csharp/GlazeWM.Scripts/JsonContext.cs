using System.Text.Json;
using System.Text.Json.Serialization;

namespace GlazeWM.Scripts;

[JsonSourceGenerationOptions(PropertyNamingPolicy = JsonKnownNamingPolicy.CamelCase)]
[JsonSerializable(typeof(JsonDocument))]
[JsonSerializable(typeof(MonitorsResponse))]
[JsonSerializable(typeof(Monitor))]
[JsonSerializable(typeof(Workspace))]
[JsonSerializable(typeof(Window))]
[JsonSerializable(typeof(State))]
[JsonSerializable(typeof(Data))]
[JsonSerializable(typeof(Left))]
public partial class JsonContext : JsonSerializerContext
{
}

