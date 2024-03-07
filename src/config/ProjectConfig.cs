namespace fox.foxie_flakey.uwumaker.project.config {
  public class ProjectConfig : Config {
    public string BuildDir;
    public string Name;
    
    public ProjectConfig(string buildDir, string path) : base(path) {
      this.BuildDir = buildDir;
      this.Name = this.Get<string>("Project.name");
    }
  }
}
