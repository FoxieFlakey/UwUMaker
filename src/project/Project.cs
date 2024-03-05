namespace fox.foxie_flakey.uwumaker {
  public class Project(string dir)
  {
    public readonly string RootDir = dir;
    public readonly string ConfigPath = Path.Join(dir, "UwUMaker.toml");
  }
}
