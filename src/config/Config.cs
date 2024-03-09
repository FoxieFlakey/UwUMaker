namespace fox.foxie_flakey.uwumaker.config;

using System.Diagnostics;
using Tomlyn.Model;

public partial class Config(string configPath, TomlTable table)
{
  public readonly string ConfigPath = configPath;
  private readonly TomlTable ConfigTable = table;

  public T Get<T>(string path) where T: class {
    TomlTable current = this.ConfigTable;
    string[] components = path.Split(".");
    
    for (int i = 0; i < components.Length; i++) {
      string component = components[i];
      
      if (component.Length == 0)
        throw new ArgumentException("Config key path contain empty string");
      if (!current.ContainsKey(component))
        throw new MissingConfigKeyException(this, $"Missing component '{component}' in config for path '{path}'");
      
      if (current[component] is TomlTable && i < components.Length - 1) {
        current = (TomlTable) this.ConfigTable[component];
        continue;
      }
      
      if (current[component] is not T)
        throw new InvalidConfigValueException(this, $"Value at '{path}' is wrongly typed, expected '{typeof(T).Name}'");
      
      return (T) current[component];
    }
    
    throw new UnreachableException();
  }
}
