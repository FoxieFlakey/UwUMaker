namespace fox.foxie_flakey.uwumaker;

public partial class Util {
  public static void EnsureDir(string path) {
    if (Directory.Exists(path))
      return;
    
    Directory.CreateDirectory(path);
  }
  
  public static void DeleteDir(string path) {
    if (!Directory.Exists(path))
      return;
    Directory.Delete(path);
  }
}
