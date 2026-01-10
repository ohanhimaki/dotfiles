using System.Text.Json.Serialization;

namespace GlazeWM.Scripts
{
    public class Data
    {
        [JsonPropertyName("monitors")]
        public System.Collections.Generic.ICollection<Monitor> Monitors { get; set; }
    }

    public class State
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("centered")]
        public bool Centered { get; set; }

        [JsonPropertyName("shownOnTop")]
        public bool ShownOnTop { get; set; }
    }

    public class BorderDelta
    {
        [JsonPropertyName("left")]
        public int Left { get; set; }

        [JsonPropertyName("top")]
        public int Top { get; set; }

        [JsonPropertyName("right")]
        public int Right { get; set; }

        [JsonPropertyName("bottom")]
        public int Bottom { get; set; }
    }

    public class Left
    {
        [JsonPropertyName("amount")]
        public double Amount { get; set; }

        [JsonPropertyName("unit")]
        public string Unit { get; set; }
    }

    public class Children
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
        public State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        [JsonPropertyName("borderDelta")]
        public BorderDelta BorderDelta { get; set; }

        [JsonPropertyName("floatingPlacement")]
        public BorderDelta FloatingPlacement { get; set; }

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

    public class Anonymous7
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
        public double TilingSize { get; set; }

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
        public State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        [JsonPropertyName("borderDelta")]
        public BorderDelta BorderDelta { get; set; }

        [JsonPropertyName("floatingPlacement")]
        public BorderDelta FloatingPlacement { get; set; }

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

    public class Anonymous9
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
        public State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        [JsonPropertyName("borderDelta")]
        public BorderDelta BorderDelta { get; set; }

        [JsonPropertyName("floatingPlacement")]
        public BorderDelta FloatingPlacement { get; set; }

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

    public class Anonymous11
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("displayName")]
        public object DisplayName { get; set; }

        [JsonPropertyName("parentId")]
        public string ParentId { get; set; }

        [JsonPropertyName("children")]
        public System.Collections.Generic.ICollection<Children> Children { get; set; }

        [JsonPropertyName("childFocusOrder")]
        public System.Collections.Generic.ICollection<string> ChildFocusOrder { get; set; }

        [JsonPropertyName("hasFocus")]
        public bool HasFocus { get; set; }

        [JsonPropertyName("isDisplayed")]
        public bool IsDisplayed { get; set; }

        [JsonPropertyName("width")]
        public int Width { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("x")]
        public int X { get; set; }

        [JsonPropertyName("y")]
        public int Y { get; set; }

        [JsonPropertyName("tilingDirection")]
        public string TilingDirection { get; set; }
    }

    public class Anonymous13
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
        public double TilingSize { get; set; }

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
        public State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        [JsonPropertyName("borderDelta")]
        public BorderDelta BorderDelta { get; set; }

        [JsonPropertyName("floatingPlacement")]
        public BorderDelta FloatingPlacement { get; set; }

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

    public class Anonymous15
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
        public double TilingSize { get; set; }

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
        public State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public string DisplayState { get; set; }

        [JsonPropertyName("borderDelta")]
        public BorderDelta BorderDelta { get; set; }

        [JsonPropertyName("floatingPlacement")]
        public BorderDelta FloatingPlacement { get; set; }

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

    public class Anonymous17
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("displayName")]
        public object DisplayName { get; set; }

        [JsonPropertyName("parentId")]
        public string ParentId { get; set; }

        [JsonPropertyName("children")]
        public System.Collections.Generic.ICollection<Anonymous13> Children { get; set; }

        [JsonPropertyName("childFocusOrder")]
        public System.Collections.Generic.ICollection<string> ChildFocusOrder { get; set; }

        [JsonPropertyName("hasFocus")]
        public bool HasFocus { get; set; }

        [JsonPropertyName("isDisplayed")]
        public bool IsDisplayed { get; set; }

        [JsonPropertyName("width")]
        public int Width { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("x")]
        public int X { get; set; }

        [JsonPropertyName("y")]
        public int Y { get; set; }

        [JsonPropertyName("tilingDirection")]
        public string TilingDirection { get; set; }
    }

    public class Monitor
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; }

        [JsonPropertyName("parentId")]
        public string ParentId { get; set; }

        [JsonPropertyName("children")]
        public System.Collections.Generic.ICollection<Anonymous11> Children { get; set; }

        [JsonPropertyName("childFocusOrder")]
        public System.Collections.Generic.ICollection<string> ChildFocusOrder { get; set; }

        [JsonPropertyName("hasFocus")]
        public bool HasFocus { get; set; }

        [JsonPropertyName("width")]
        public int Width { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("x")]
        public int X { get; set; }

        [JsonPropertyName("y")]
        public int Y { get; set; }

        [JsonPropertyName("dpi")]
        public int Dpi { get; set; }

        [JsonPropertyName("scaleFactor")]
        public double ScaleFactor { get; set; }

        [JsonPropertyName("handle")]
        public int Handle { get; set; }

        [JsonPropertyName("deviceName")]
        public string DeviceName { get; set; }

        [JsonPropertyName("devicePath")]
        public string DevicePath { get; set; }

        [JsonPropertyName("hardwareId")]
        public string HardwareId { get; set; }

        [JsonPropertyName("workingRect")]
        public BorderDelta WorkingRect { get; set; }
    }

    public class MonitorsResponse
    {
        [JsonPropertyName("clientMessage")]
        public string ClientMessage { get; set; }

        [JsonPropertyName("data")]
        public Data Data { get; set; }

        [JsonPropertyName("error")]
        public object Error { get; set; }

        [JsonPropertyName("success")]
        public bool Success { get; set; }
    }


}
