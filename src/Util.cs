using System.Security.Cryptography;
using System.Text;

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
  
  public static string HashSHA256(string str) {
    return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(str)));
  }
}
