using System.Diagnostics;
using Tomlyn;
using Tomlyn.Model;

namespace fox.foxie_flakey.uwumaker.project.config {
  public class Config {
    public string ConfigPath;
    public TomlTable ConfigTable;
    
    public Config(string configPath) {
      this.ConfigPath = configPath;

      using TextReader reader = File.OpenText(configPath);
      this.ConfigTable = Toml.ToModel(reader.ReadToEnd());
    }
    
    public void Reload() {
      using TextReader reader = File.OpenText(this.ConfigPath);
      this.ConfigTable = Toml.ToModel(reader.ReadToEnd());
    }
    
    public void Save() {
      Console.WriteLine(Toml.FromModel(this.ConfigTable));
    }
    
    public T Get<T>(string path) where T: class {
      TomlTable current = this.ConfigTable;
      foreach (var component in path.Split(".")) {
        if (component.Length == 0)
          throw new ArgumentException("Config key path contain empty string");
        if (!current.ContainsKey(component))
          throw new MissingConfigKeyException(this, $"Missing component '{component}' in config for path '{path}'");
        
        if (current[component] as TomlTable != null) {
          current = (TomlTable) this.ConfigTable[component];
          continue;
        }
        
        if (current[component] as T == null)
          throw new InvalidConfigValueException(this, $"Value at '{path}' is wrongly typed, expected '{typeof(T).Name}'");
        
        return (T) current[component];
      }
      
      throw new UnreachableException();
    }
    
    public void Set<T>(string key, T value) where T: class {
      // TODO: Should warn on incorrect type?
      this.ConfigTable[key] = value;
    }
  }
}
