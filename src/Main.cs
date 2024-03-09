namespace fox.foxie_flakey.uwumaker;

using fox.foxie_flakey.uwumaker.config;
using fox.foxie_flakey.uwumaker.project;

public class Program {
  public static void Main() {
    Console.WriteLine("Hello World! UwU");
    var project = new Project(Directory.GetCurrentDirectory());
    Console.WriteLine($"Loaded project at '{project.ConfigPath}' as config");
    Console.WriteLine($"Project name is {project.Config.Name}");
    Console.WriteLine($"Project type is {project.Config.Type}");
    Console.WriteLine($"CONFIG_HELLO is {project.DotConfig.GetBool("HELLO")}");
    
    foreach (string file in new SubdirConfig(project, "/").SourceFiles)
      Console.WriteLine($"There is '{file}' file");
  }
}
