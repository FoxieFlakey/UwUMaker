namespace fox.foxie_flakey.uwumaker;

public class Program {
  public static void Main() {
    Console.WriteLine("Hello World! UwU");
    var config = new Project(Directory.GetCurrentDirectory());
    Console.WriteLine($"Loaded project at '{config.ConfigPath}' as config");
    Console.WriteLine($"Project name is {config.Config.Name}");
    Console.WriteLine($"Project type is {config.Config.Type}");
    Console.WriteLine($"CONFIG_HELLO is {config.DotConfig.GetInt("HELLO")}");
    Console.WriteLine($"CONFIG_SWAP_NAME is {config.DotConfig.GetBool("SWAP_NAME")}");
  }
}
