using System.Text.Json;
using GlazeWmScripts.GlazeWm.Scripts.Models;

namespace GlazeWmScripts.GlazeWm.Scripts
{
    public static class WorkspaceChildExtensions
    {
        /// <summary>
        /// Recursively flattens the child hierarchy and returns all Window nodes.
        /// </summary>
        public static IEnumerable<Window> GetAllWindows(this IEnumerable<WorkspaceChild> children)
        {
            foreach (var child in children)
            {
                if (child is Window w)
                    yield return w;
                else if (child is Split s)
                    foreach (var nested in s.Children.GetAllWindows())
                        yield return nested;
            }
        }

        /// <summary>
        /// Recursively traverses a JsonElement that has a "children" array and yields
        /// all descendant elements whose "type" is "window".
        /// </summary>
        public static IEnumerable<JsonElement> FlattenWindowElements(JsonElement element)
        {
            if (!element.TryGetProperty("children", out var children)) yield break;
            foreach (var child in children.EnumerateArray())
            {
                var type = child.GetProperty("type").GetString();
                if (type == "window")
                    yield return child;
                else if (type == "split")
                    foreach (var nested in FlattenWindowElements(child))
                        yield return nested;
            }
        }
    }
}
