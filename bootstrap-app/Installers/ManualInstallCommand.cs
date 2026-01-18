namespace Dotfiles.Installers;

public class ManualInstallCommand : IInstallCommand
{
    private readonly string _instructions;

    public ManualInstallCommand(string instructions)
    {
        _instructions = instructions;
    }

    public bool Execute()
    {
        Console.WriteLine($"  ℹ {_instructions}");
        return true;
    }

    public string GetDescription() => _instructions;
}
