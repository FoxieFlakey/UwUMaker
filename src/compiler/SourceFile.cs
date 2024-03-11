namespace fox.foxie_flakey.uwumaker.compiler;

using System.Threading.Tasks;
using fox.foxie_flakey.uwumaker.project;

public class SourceFile(ICompiler compiler, string path, Subdir origin) {
  public readonly ICompiler Compiler = compiler;
  public readonly string Path = path;
  public readonly Subdir Origin = origin;
  
  public async Task<string?> Compile() {
    await this.Origin.ParentProject.PrintOutput(this.Compiler.GetShortName(), this.Path);
    string outputPath = await this.Origin.ParentProject.GenOutputPath(this.Path, ".o");
    
    // Failed to compile
    if (!await this.Compiler.Compile(this.Path, outputPath))
      return null;
    return outputPath;
  }
}
