using System.Text.Json;
using Dotfiles.Models;

namespace Dotfiles.Services;

public class ConfigService
{
    private readonly string _configPath;

    public ConfigService(string dotfilesPath)
    {
        _configPath = Path.Combine(dotfilesPath, ".bootstrap-config.json");
    }

    public BootstrapConfig? LoadConfig()
    {
        try
        {
            if (!File.Exists(_configPath))
                return null;

            var json = File.ReadAllText(_configPath);
            return JsonSerializer.Deserialize<BootstrapConfig>(json);
        }
        catch
        {
            return null;
        }
    }

    public void SaveConfig(BootstrapConfig config)
    {
        try
        {
            var options = new JsonSerializerOptions { WriteIndented = true };
            var json = JsonSerializer.Serialize(config, options);
            File.WriteAllText(_configPath, json);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Warning: Failed to save config: {ex.Message}");
        }
    }
}
