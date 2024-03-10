namespace fox.foxie_flakey.uwumaker.compiler;

using System.Text.Json;
using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.project;

public class SourceFile(ICompiler compiler, string path, Subdir origin) {
  public readonly ICompiler Compiler = compiler;
  public readonly string Path = path;
  public readonly Subdir Origin = origin;
  
  private struct SourceMetadata {
    public string SourcePath;
  }

  private static readonly JsonSerializerOptions JsonOpts = new() {
    IncludeFields = true
  };
  
  public async Task<bool> Compile() {
    Console.WriteLine($"[ {this.Compiler.GetShortName().PadRight(10)} ] {this.Path}");
    string hash = Util.HashSHA256(this.Path);
    string outputPath = System.IO.Path.Join(this.Origin.ParentProject.BuildObjectsDir, hash + ".o");
    string metadataPath = System.IO.Path.Join(this.Origin.ParentProject.BuildObjectsDir, hash + ".json");
    
    SourceMetadata meta = new() {
      SourcePath = this.Path
    };
    
    await File.WriteAllTextAsync(metadataPath, JsonSerializer.Serialize(meta, JsonOpts));
     
    // Failed to compile
    return await this.Compiler.Compile(this.Path, outputPath);
  }
}
