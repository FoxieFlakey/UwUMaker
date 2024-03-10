namespace fox.foxie_flakey.uwumaker.project;

using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.compiler;
using fox.foxie_flakey.uwumaker.config;

public class Subdir : ICompileableUnit {
  public readonly string Path;
  public readonly Project ParentProject;
  public readonly SubdirConfig Config;
  
  public Subdir(Project parentProject, string dir) {
    this.Path = dir;
    this.ParentProject = parentProject;
    this.Config = new SubdirConfig(dir, parentProject);
  }

  public async Task Clean() {
    Console.WriteLine($"[ CLEAN   ] Cleaning...");
    await Task.Delay(1);
  }

  private struct SourceMetadata {
    public string SourcePath;
  }

  private static readonly JsonSerializerOptions JsonOpts = new() {
    IncludeFields = true
  };
  
  public async Task<bool> Compile() {
    foreach (var source in this.Config.SourceFiles) {
      Console.WriteLine($"[ CC    ] {source}");
      string hash = uwumaker.Util.HashSHA256(source);
      string outputPath = System.IO.Path.Join(this.ParentProject.BuildObjectsDir, hash + ".o");
      string metadataPath = System.IO.Path.Join(this.ParentProject.BuildObjectsDir, hash + ".json");
      
      SourceMetadata meta = new() {
        SourcePath = source
      };
      
      await File.WriteAllTextAsync(metadataPath, JsonSerializer.Serialize(meta, JsonOpts));
      if (!await CompilerRegistry.GetCompilerFor("c").Compile(source, outputPath))
        return false;
    }
    return true;
  }
}
