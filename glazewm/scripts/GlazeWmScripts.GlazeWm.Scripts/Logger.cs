namespace GlazeWmScripts.GlazeWm.Scripts
{
    public static class Logger
    {
        public static void Log(string message)
        {
            if(false) return; // Disable logging globally by changing false to true
            Console.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {message}");
        }
    }
}

