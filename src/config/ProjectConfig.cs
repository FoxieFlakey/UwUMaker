namespace fox.foxie_flakey.uwumaker.config;

public class ProjectConfig : Config {
  public string Name {
    get => this.Get<string>("Project.name");
  }
  
  public Project.Type Type {
    get => this.Get<string>("Project.type") switch {
      "executable" => Project.Type.Executable,
      "library" => Project.Type.Library,
      _ => throw new InvalidConfigValueException(this, $"Unknown project type")
    };
  }
  
  public ProjectConfig(string path) : base(path) {
  }
}
