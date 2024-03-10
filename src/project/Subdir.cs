namespace fox.foxie_flakey.uwumaker.project;

using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.compiler;
using fox.foxie_flakey.uwumaker.config;

public class Subdir : ICompileableUnit {
  public readonly string Path;
  public readonly Project ParentProject;
  public readonly SubdirConfig Config;
  public readonly IList<SourceFile> Sources = new List<SourceFile>();
  
  public Subdir(Project parentProject, string dir) {
    this.Path = dir;
    this.ParentProject = parentProject;
    this.Config = new SubdirConfig(dir, parentProject);
    
    foreach (var lang in this.Config.SourceFiles) {
      ICompiler compiler = CompilerRegistry.GetCompilerFor(lang.Key);
      foreach (string filePath in lang.Value)
        this.Sources.Add(new SourceFile(compiler, filePath, this));
    }
  }

  public Task Clean() {
    return Task.CompletedTask;
  }

  public async Task<bool> Compile() {
    foreach (var source in this.Sources)
      if (!await source.Compile())
        return false;
    return true;
  }
}
