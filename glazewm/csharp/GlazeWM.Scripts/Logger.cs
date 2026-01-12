namespace GlazeWM.Scripts;

public static class Logger
{
    // Set to false to disable all logging for better performance
    private static readonly bool IsEnabled = false;

    public static void Log(string message)
    {
        if (IsEnabled)
        {
            Console.WriteLine(message);
        }
    }
}

