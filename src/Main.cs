namespace fox.foxie_flakey.uwumaker;

using fox.foxie_flakey.uwumaker.config;
using fox.foxie_flakey.uwumaker.project;

public class Program {
  public static void Main() {
    Console.WriteLine("Hello World! UwU");
    var project = new Project(Directory.GetCurrentDirectory());
    Console.WriteLine($"Project name is {project.Config.Name}");
    Console.WriteLine($"Project type is {project.Config.Type}");
    string? compileResult = project.Compile().GetAwaiter().GetResult();
    Console.WriteLine($"Compile result at = {compileResult}");
  }
}
