using System.Text.Json.Serialization;

namespace GlazeWmScripts.GlazeWm.Scripts.Models
{
    public class DataWorkspaces
    {
        [JsonPropertyName("workspaces")]
        public System.Collections.Generic.ICollection<Workspace> Workspaces { get; set; }
    }




    


    


    public class WorkspacesResponse
    {
        [JsonPropertyName("clientMessage")]
        public string ClientMessage { get; set; }

        [JsonPropertyName("data")]
        public DataWorkspaces Data { get; set; }

        [JsonPropertyName("error")]
        public object Error { get; set; }

        [JsonPropertyName("success")]
        public bool Success { get; set; }
    }
}
