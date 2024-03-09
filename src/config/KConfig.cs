namespace fox.foxie_flakey.uwumaker.config;

public class DotConfig {
  public string Path;
  public readonly string DotConfigKeyPrefix = "CONFIG_";
  
  // value can be only one of string, bool, and integer
  private readonly Dictionary<string, object> Options = [];
  
  public DotConfig(string path) {
    using TextReader reader = File.OpenText(path);
    this.Path = path;
    
    int lineNumber = 0;
    var line = reader.ReadLine();
    for (; line is not null; line = reader.ReadLine()) {
      lineNumber++;
      line = line.Trim(); 
      
      // If comment or empty line skip
      if (line == "" || line.First() == '#')
        continue;
      
      string[] tokens = line.Split("=", 2);
      if (tokens.Length != 2 || !tokens[0].StartsWith(DotConfigKeyPrefix))
        throw new InvalidDataException($"Invalid kconfig line at line {lineNumber}");
      
      string key = tokens[0];
      string value = tokens[1];
      SetConfig(lineNumber, key[DotConfigKeyPrefix.Length..], value);
    }
  }
  
  private void SetConfig(int lineNumber, string key, string value) {
    switch (value.First()) {
      // Its a string
      case '"':
        if (value.Last() != '"')
          throw new InvalidDataException($"String not terminated at line {lineNumber}");
        this.Options[key] = value[1..(value.Length - 1)];
        break;
      
      // Its a number
      case '0': case '1': case '2': case '3': case '4':
      case '5': case '6': case '7': case '8': case '9':
        try {
          this.Options[key] = Int32.Parse(value);
          Console.WriteLine($"Key {key} assigned by {value}");
        } catch (FormatException e) {
          throw new InvalidDataException($"Error parsing integer at line {lineNumber}", e);
        }
        break;
      
      // Its a bool
      case 'y':
        this.Options[key] = true;
        break;
      case 'n':
        this.Options[key] = false;
        break;
      
      // Unknown value type
      default:
        throw new InvalidDataException($"Unknown config value type at line {lineNumber}");;
    }
  }
  
  public bool GetBool(string key) {
    if (this.Options[key] is not bool)
      throw new ArgumentException("Key refered to non boolean value");
    
    return (bool) this.Options[key];
  }
  public string GetString(string key) {
    if (this.Options[key] is not string)
      throw new ArgumentException("Key refered to non string value");
    
    return (string) this.Options[key];
  }
  public int GetInt(string key) {
    if (this.Options[key] is not int)
      throw new ArgumentException("Key refered to non integer value");
    
    return (int) this.Options[key];
  }

  public Boolean IsExist(string key) {
    return this.Options.ContainsKey(key);
  }
}

