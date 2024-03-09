namespace fox.foxie_flakey.uwumaker.config;

using System.Diagnostics;
using Tomlyn;
using Tomlyn.Model;

public class Config {
  public string Path;
  private TomlTable ConfigTable;
  
  public Config(string configPath) {
    this.Path = configPath;

    using TextReader reader = File.OpenText(configPath);
    this.ConfigTable = Toml.ToModel(reader.ReadToEnd());
  }
  
  public void Reload() {
    using TextReader reader = File.OpenText(this.Path);
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
      
      if (current[component] is TomlTable) {
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
