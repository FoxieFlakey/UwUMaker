namespace fox.foxie_flakey.uwumaker.project;

using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text.Json;
using fox.foxie_flakey.uwumaker.config;
using Tomlyn;

public class Project : ICompileableUnit {
  public readonly Subdir RootDir;
  public readonly string BuildDir;
  public readonly string BuildObjectsDir;
  public readonly string ConfigPath;
  public readonly string DotConfigPath;
  
  public readonly ProjectConfig Config;
  public readonly DotConfig DotConfig;
  
  public Project(string dir, DotConfig? dotConfig) {
    if (dotConfig is not null) {
      this.DotConfigPath = dotConfig.Path;
      this.DotConfig = dotConfig;
    } else {
      this.DotConfigPath = Path.Join(dir, "/.config");
      this.DotConfig = new DotConfig(this.DotConfigPath);
    }
    
    this.BuildDir = Path.Join(dir, "/build");
    this.BuildObjectsDir = Path.Join(this.BuildDir, "/objs");
    this.ConfigPath = Path.Join(dir, "/UwUMaker.toml");
    
    this.Config = new ProjectConfig(this.ConfigPath, Util.ApplyConditional(Toml.ToModel(File.ReadAllText(this.ConfigPath)), this.DotConfig));
    this.RootDir = new(this, dir);
  }
  
  public Project(string dir, string dotConfigPath) : this(dir, new DotConfig(Path.Combine(dir, dotConfigPath))) {
  }
  
  public Project(string dir) : this(dir, dotConfig: null) {
  }
  
  public async Task<string?> Compile() {
    uwumaker.Util.EnsureDir(this.BuildDir);
    uwumaker.Util.EnsureDir(this.BuildObjectsDir);
    string? finalObjectFile = await this.RootDir.Compile(); 
    if (finalObjectFile is null)
      return null;
    string linkOutput = await this.GenOutputPath(this.RootDir.SubdirPath, "");
    
    string[] linkCommand = [
      "cc",
      "-o",
      linkOutput,
      "--",
      finalObjectFile
    ];
    
    await this.PrintOutput("LD", linkOutput);
    var process = Process.Start("/usr/bin/env", linkCommand);
    await process.WaitForExitAsync();
    return linkOutput;
  }
  
  public async Task Clean() {
    await this.RootDir.Clean();
  }
  
  public async Task CleanSanitize() {
    await ((ICompileableUnit) this.RootDir).CleanSanitize();
  }
  
  private static readonly JsonSerializerOptions JsonOpts = new() {
    IncludeFields = true
  };
  
  private struct OutputMetadata {
    public string InputPath;
  };
  
  public async Task<string> GenOutputPath(string uniqueID, string postfix) {
    string hash = uwumaker.Util.HashSHA256(uniqueID);
    string outputPath = Path.Join(this.BuildObjectsDir, hash + postfix);
    string metadataPath = Path.Join(this.BuildObjectsDir, hash + postfix + ".json");
    
    OutputMetadata meta = new() {
      InputPath = uniqueID
    };
    
    await File.WriteAllTextAsync(metadataPath, JsonSerializer.Serialize(meta, JsonOpts));
    return outputPath;
  }
  
  public async Task PrintOutput(string tool, string message) {
    await Console.Out.WriteLineAsync($"[ {tool,-10} ] {message}");
  }
  
  public enum Type {
    Executable,
    Library
  };
}
