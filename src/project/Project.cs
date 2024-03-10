namespace fox.foxie_flakey.uwumaker.project;

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
  
  public async Task<bool> Compile() {
    uwumaker.Util.EnsureDir(this.BuildDir);
    uwumaker.Util.EnsureDir(this.BuildObjectsDir);
    return await this.RootDir.Compile(); 
  }
  
  public async Task Clean() {
    await this.RootDir.Clean();
  }
  
  public async Task CleanSanitize() {
    await ((ICompileableUnit) this.RootDir).CleanSanitize();
  }
  
  public enum Type {
    Executable,
    Library
  };
}
