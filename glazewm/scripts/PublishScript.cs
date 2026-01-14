

Console.WriteLine("Starting publish script...");

string projectPath = "./GlazeWmScripts.GlazeWm.Scripts/GlazeWmScripts.GlazeWm.Scripts.csproj";
string outputPath = "./publish/";
string configuration = "Release";
string runtime = "win-x64"; // Change this to your target runtime if needed


// run publish command to putputPath
// manual command is dotnet publish -c Release --self-contained true -r win-x64 /p:PublishSingleFile=true /p:PublishReadyToRun=true /p:PublishTrimmed=true
var publishProcess = new System.Diagnostics.Process();
publishProcess.StartInfo.FileName = "dotnet";

publishProcess.StartInfo.Arguments = $"publish {projectPath} -c {configuration} --self-contained true -r {runtime} /p:PublishSingleFile=true /p:PublishReadyToRun=true /p:PublishTrimmed=true -o {outputPath}";
publishProcess.StartInfo.RedirectStandardOutput = true;
publishProcess.StartInfo.RedirectStandardError = true;
publishProcess.StartInfo.UseShellExecute = false;
publishProcess.StartInfo.CreateNoWindow = true;
publishProcess.Start();
string output = publishProcess.StandardOutput.ReadToEnd();
string error = publishProcess.StandardError.ReadToEnd();
publishProcess.WaitForExit();
if (publishProcess.ExitCode != 0)
{
    Console.WriteLine("Publish failed with the following error:");
    Console.WriteLine(error);
}
else
{
    Console.WriteLine("Publish succeeded. Output:");
    Console.WriteLine(output);
}
Console.WriteLine("Publish script completed.");



//ask if user wants to overwrite exe file to  c:/projects/bin/ folder?
Console.WriteLine("Do you want to copy the published executable to C:/projects/bin/? (y/n)");
string response = Console.ReadLine();
if (response.ToLower() == "y")
{
    string sourceFile = System.IO.Path.Combine(outputPath, "GlazeWmScripts.GlazeWm.Scripts.exe");
    string destinationFile = "C:/projects/bin/GlazeWmScripts.GlazeWm.Scripts.exe";

    try
    {
        System.IO.File.Copy(sourceFile, destinationFile, true);
        Console.WriteLine("Executable copied successfully to C:/projects/bin/");
    }
    catch (Exception ex)
    {
        Console.WriteLine("Failed to copy the executable. Error:");
        Console.WriteLine(ex.Message);
    }
}
else
{
    Console.WriteLine("Executable copy skipped.");
}

