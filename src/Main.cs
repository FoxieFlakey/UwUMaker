
namespace fox.foxie_flakey.uwumaker {
  public class Program {
    public static void Main() {
      Console.WriteLine("Hello World! UwU");
      var project = new Project(Directory.GetCurrentDirectory());
      Console.WriteLine($"Loaded project at '{project.RootDir}' using '{project.ConfigPath}' as config");
    }
  }
}
