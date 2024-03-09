namespace fox.foxie_flakey.uwumaker;

using fox.foxie_flakey.uwumaker.config;

public class Project {
  public string RootDir;
  public string ConfigPath;
  public string DotConfigPath;
  public ProjectConfig Config;
  public DotConfig DotConfig;
  
  public Project(string dir, DotConfig? dotConfig) {
    this.RootDir = dir;
    this.ConfigPath = Path.Join(dir, "/UwUMaker.toml");
    this.Config = new ProjectConfig(this.ConfigPath);
    
    if (dotConfig is not null) {
      this.DotConfigPath = dotConfig.Path;
      this.DotConfig = dotConfig;
    } else {
      this.DotConfigPath = Path.Join(dir, "/.config");
      this.DotConfig = new DotConfig(this.DotConfigPath);
    }
    this.Config.ApplyConditional(this.DotConfig);
  }
  
  public Project(string dir, string dotConfigPath) : this(dir, new DotConfig(Path.Combine(dir, dotConfigPath))) {
  }
  
  public Project(string dir) : this(dir, dotConfig: null) {
  }
  
  public enum Type {
    Executable,
    Library
  };
}
