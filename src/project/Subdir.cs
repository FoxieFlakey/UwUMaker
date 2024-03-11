namespace fox.foxie_flakey.uwumaker.project;

using System.Diagnostics;
using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.compiler;
using fox.foxie_flakey.uwumaker.config;

public class Subdir : ICompileableUnit {
  public readonly string SubdirPath;
  public readonly Project ParentProject;
  public readonly SubdirConfig Config;
  public readonly IList<SourceFile> Sources = new List<SourceFile>();
  
  public Subdir(Project parentProject, string dir) {
    this.SubdirPath = dir;
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

  public async Task<string?> Compile() {
    string archiveOutput = await this.ParentProject.GenOutputPath(this.Config.ConfigPath, ".a");
    string[] arCommand = [
      "ar",
      "--thin",
      "rcsP",
      archiveOutput,
      "--"
    ];
    
    string[] objectFiles = new string[this.Sources.Count];
    int index = 0;
    foreach (var source in this.Sources) {
      var objectFile = await source.Compile();
      if (objectFile is null)
        return null;
      
      objectFiles[index] = objectFile;
      index++;
    }
    
    await this.ParentProject.PrintOutput("AR", archiveOutput);
    var process = Process.Start("/usr/bin/env", arCommand.Concat(objectFiles));
    await process.WaitForExitAsync();
    if (process.ExitCode != 0)
      return "";
    return archiveOutput;
  }
}
