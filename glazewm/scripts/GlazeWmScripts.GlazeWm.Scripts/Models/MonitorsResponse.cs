using System.Text.Json.Serialization;

namespace GlazeWmScripts.GlazeWm.Scripts.Models
{
    public class Data
    {
        [JsonPropertyName("monitors")]
        public required ICollection<Monitor> Monitors { get; set; }
    }

    public class State
    {
        [JsonPropertyName("type")]
        public required string Type { get; set; }

        [JsonPropertyName("centered")]
        public bool Centered { get; set; }

        [JsonPropertyName("shownOnTop")]
        public bool ShownOnTop { get; set; }
    }

    public class Left
    {
        [JsonPropertyName("amount")]
        public double Amount { get; set; }

        [JsonPropertyName("unit")]
        public required string Unit { get; set; }
    }

    /// <summary>
    /// Base type for anything that can appear inside a Workspace or Split's children list.
    /// The "type" JSON discriminator determines whether the node is a Window or a Split.
    /// </summary>
    [JsonPolymorphic(TypeDiscriminatorPropertyName = "type")]
    [JsonDerivedType(typeof(Window), "window")]
    [JsonDerivedType(typeof(Split), "split")]
    public abstract class WorkspaceChild
    {
        [JsonPropertyName("id")]
        public required string Id { get; set; }

        [JsonPropertyName("parentId")]
        public required string ParentId { get; set; }

        [JsonPropertyName("hasFocus")]
        public bool HasFocus { get; set; }

        [JsonPropertyName("tilingSize")]
        public object? TilingSize { get; set; }

        [JsonPropertyName("width")]
        public int Width { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("x")]
        public int X { get; set; }

        [JsonPropertyName("y")]
        public int Y { get; set; }
    }

    public class Window : WorkspaceChild
    {
        [JsonPropertyName("state")]
        public required State State { get; set; }

        [JsonPropertyName("prevState")]
        public required State PrevState { get; set; }

        [JsonPropertyName("displayState")]
        public required string DisplayState { get; set; }

        [JsonPropertyName("handle")]
        public int Handle { get; set; }

        [JsonPropertyName("title")]
        public required string Title { get; set; }

        [JsonPropertyName("className")]
        public required string ClassName { get; set; }

        [JsonPropertyName("processName")]
        public required string ProcessName { get; set; }

        [JsonPropertyName("activeDrag")]
        public object? ActiveDrag { get; set; }
    }

    /// <summary>
    /// A tiling split container. Its children can be Windows or further nested Splits.
    /// </summary>
    public class Split : WorkspaceChild
    {
        [JsonPropertyName("children")]
        public ICollection<WorkspaceChild> Children { get; set; } = new List<WorkspaceChild>();

        [JsonPropertyName("childFocusOrder")]
        public ICollection<string> ChildFocusOrder { get; set; } = new List<string>();

        [JsonPropertyName("tilingDirection")]
        public string? TilingDirection { get; set; }
    }

    public class Workspace
    {
        [JsonPropertyName("type")]
        public string? Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; } = "";

        [JsonPropertyName("name")]
        public string Name { get; set; } = "";

        [JsonPropertyName("displayName")]
        public object? DisplayName { get; set; }

        [JsonPropertyName("parentId")]
        public string ParentId { get; set; } = "";

        [JsonPropertyName("children")]
        public ICollection<WorkspaceChild> Children { get; set; } = new List<WorkspaceChild>();

        [JsonPropertyName("childFocusOrder")]
        public ICollection<string> ChildFocusOrder { get; set; } = new List<string>();

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
        public string? TilingDirection { get; set; }
    }

    public class Monitor
    {
        [JsonPropertyName("type")]
        public string? Type { get; set; }

        [JsonPropertyName("id")]
        public string Id { get; set; } = "";

        [JsonPropertyName("parentId")]
        public string? ParentId { get; set; }

        [JsonPropertyName("children")]
        public ICollection<Workspace> Children { get; set; } = new List<Workspace>();

        [JsonPropertyName("childFocusOrder")]
        public ICollection<string> ChildFocusOrder { get; set; } = new List<string>();

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
        public string? DeviceName { get; set; }

        [JsonPropertyName("devicePath")]
        public string? DevicePath { get; set; }

        [JsonPropertyName("hardwareId")]
        public string? HardwareId { get; set; }
    }

    public class MonitorsResponse
    {
        [JsonPropertyName("clientMessage")]
        public string? ClientMessage { get; set; }

        [JsonPropertyName("data")]
        public Data? Data { get; set; }

        [JsonPropertyName("error")]
        public object? Error { get; set; }

        [JsonPropertyName("success")]
        public bool Success { get; set; }
    }
}
