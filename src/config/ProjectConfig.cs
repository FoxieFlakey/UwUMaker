namespace fox.foxie_flakey.uwumaker.config;

public class ProjectConfig : Config {
  public string Name;
  public Project.Type Type;
  
  public ProjectConfig(string path) : base(path) {
    this.Name = this.Get<string>("Project.name");
    this.Type = this.Get<string>("Project.type") switch {
      "executable" => Project.Type.Executable,
      "library" => Project.Type.Library,
      _ => throw new InvalidConfigValueException(this, $"Unknown project type")
    };
  }
}
