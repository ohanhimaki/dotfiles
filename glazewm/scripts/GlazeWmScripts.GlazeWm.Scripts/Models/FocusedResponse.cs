using System.Text.Json.Serialization;

namespace GlazeWmScripts.GlazeWm.Scripts.Models
{
    public class FocusedData
    {
        [JsonPropertyName("focused")]
        public Focused Focused { get; set; }
    }

    public class Focused
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("parentId")]
        public string ParentId { get; set; }

        [JsonPropertyName("hasFocus")]
        public bool HasFocus { get; set; }

        [JsonPropertyName("tilingSize")]
        public object TilingSize { get; set; }

        [JsonPropertyName("width")]
        public int Width { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("x")]
        public int X { get; set; }

        [JsonPropertyName("y")]
        public int Y { get; set; }

        [JsonPropertyName("state")]
        public State State { get; set; }

        [JsonPropertyName("prevState")]
        public Focused PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        // [JsonPropertyName("borderDelta")]
        // public BorderDelta BorderDelta { get; set; }
        //
        // [JsonPropertyName("floatingPlacement")]
        // public BorderDelta FloatingPlacement { get; set; }

        [JsonPropertyName("handle")]
        public int Handle { get; set; }

        [JsonPropertyName("title")]
        public string Title { get; set; }

        [JsonPropertyName("className")]
        public string ClassName { get; set; }

        [JsonPropertyName("processName")]
        public string ProcessName { get; set; }

        [JsonPropertyName("activeDrag")]
        public object ActiveDrag { get; set; }
    }

    // public class State
    // {
    //     [JsonPropertyName("type")]
    //     public string Type { get; set; }
    //
    //     [JsonPropertyName("centered")]
    //     public bool Centered { get; set; }
    //
    //     [JsonPropertyName("shownOnTop")]
    //     public bool ShownOnTop { get; set; }
    // }
    //
    // public class BorderDelta
    // {
    //     [JsonPropertyName("left")]
    //     public int Left { get; set; }
    //
    //     [JsonPropertyName("top")]
    //     public int Top { get; set; }
    //
    //     [JsonPropertyName("right")]
    //     public int Right { get; set; }
    //
    //     [JsonPropertyName("bottom")]
    //     public int Bottom { get; set; }
    // }
    //

    public class FocusedResponse
    {
        [JsonPropertyName("clientMessage")]
        public string ClientMessage { get; set; }

        [JsonPropertyName("data")]
        public FocusedData Data { get; set; }

        [JsonPropertyName("error")]
        public object Error { get; set; }

        [JsonPropertyName("success")]
        public bool Success { get; set; }
    }
}
