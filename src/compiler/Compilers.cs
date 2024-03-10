using System.Diagnostics;

namespace fox.foxie_flakey.uwumaker.compiler;

public interface ICompiler {
  public string GetFullName();
  public string GetShortName();
  
  // Compile must generate linkable output at "outputPath" given source "sourcePath"
  // with "options" as the options
  public Task<bool> Compile(string sourcePath, string outputPath);
}

public class CCompiler : ICompiler {
  public string GetFullName() {
    return "C compiler";
  }
  
  public string GetShortName() {
    return "CC";
  }
  
  public async Task<bool> Compile(string sourcePath, string outputPath) {
    string[] args = ["cc", "-c", sourcePath, "-o", outputPath];
    using Process process = Process.Start("/usr/bin/env", args);
    await process.WaitForExitAsync();
    if (process.ExitCode != 0)
      return false;
    return true;
  }
}

public class CompilerRegistry {
  private static readonly Dictionary<string, ICompiler> Compilers = new() {
    {"c", new CCompiler()}
  };
  
  public static ICompiler GetCompilerFor(string langID) {
    return CompilerRegistry.Compilers[langID];
  }
  
  public static void Register(string langID, ICompiler compiler) {
    CompilerRegistry.Compilers[langID] = compiler;
  }
}
