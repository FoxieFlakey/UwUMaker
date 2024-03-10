namespace fox.foxie_flakey.uwumaker.project;

using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.config;

public class Subdir : ICompileableUnit {
  public readonly string Path;
  public readonly string OutputFile;
  public readonly SubdirConfig Config;
  
  public Subdir(Project parentProject, string dir) {
    this.Path = dir;
    this.OutputFile = System.IO.Path.Join(parentProject.BuildObjectsDir, "/" + System.IO.Path.GetFileName(dir));
    this.Config = new SubdirConfig(parentProject);
  }

  public async Task Clean() {
    Console.WriteLine($"[ CLEAN   ] Cleaning...");
    await Task.Delay(1);
  }

  public async Task<bool> Compile() {
    foreach (var source in this.Config.SourceFiles) {
      Console.WriteLine($"[ CC    ] {source}");
      await Task.Delay(1000);
    }
    return true;
  }
}
