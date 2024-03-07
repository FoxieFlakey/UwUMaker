namespace fox.foxie_flakey.uwumaker {
  public class Project {
    public readonly string RootDir;
    public readonly string ConfigPath;
    
    public Project(string dir) {
      this.RootDir = dir;
      this.ConfigPath = Path.Join(dir, "/UwUMaker.toml");
    }
  }
}
