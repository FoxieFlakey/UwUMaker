namespace fox.foxie_flakey.uwumaker.config;

using fox.foxie_flakey.uwumaker.project;
using Tomlyn.Model;

public class ProjectConfig : Config {
  public readonly string Name;
  
  public readonly Project.Type Type;
  
  public ProjectConfig(string path, TomlTable configTable) : base(path, configTable) {
    this.Name = this.Get<string>("Project.name");
    this.Type = this.Get<string>("Project.type") switch {
      "executable" => Project.Type.Executable,
      "library" => Project.Type.Library,
      _ => throw new InvalidConfigValueException(this, $"Unknown project type")
    };
  }
}
