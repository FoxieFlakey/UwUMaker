using fox.foxie_flakey.uwumaker.project.config;

namespace fox.foxie_flakey.uwumaker {
  public class Program {
    public static void Main() {
      Console.WriteLine("Hello World! UwU");
      var config = new ProjectConfig("", Path.Join(Directory.GetCurrentDirectory(), "/UwUMaker.toml"));
      Console.WriteLine($"Loaded project at '{config.ConfigPath}' as config");
      Console.WriteLine($"Project name is {config.Name}");
    }
  }
}
