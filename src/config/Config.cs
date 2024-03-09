namespace fox.foxie_flakey.uwumaker.config;

using System.Diagnostics;
using System.Reflection;
using System.Text.RegularExpressions;
using Tomlyn;
using Tomlyn.Model;

public partial class Config {
  public string Path;
  
  private bool ConditionalApplied = false;
  private TomlTable ConfigTable;
  
  public Config(string configPath) {
    this.Path = configPath;

    using TextReader reader = File.OpenText(configPath);
    this.ConfigTable = Toml.ToModel(reader.ReadToEnd());
  }
  
  [GeneratedRegex("^(.+)[-]CONFIG_(.+?)$")]
  private static partial Regex ConditionalKeyMatchRegex();
  private void ApplyConditionalOnOne(TomlTable table, DotConfig dotConfig) {
    foreach (string currentField in table.Keys) {
      IList<Match> match = ConditionalKeyMatchRegex().Matches(currentField);
      if (match.Count == 0)
        continue;
      
      string targetField = match[0].Groups[1].Value;
      string configKey = match[0].Groups[2].Value;
      
      Console.WriteLine($"Attempting to '{targetField}' with config '{configKey}' from '{currentField}'");
      
      // The corresponding config key isn't enabled
      // or missing so skip
      if (!dotConfig.ContainsKey(configKey) || !dotConfig.GetBool(configKey))
        continue;
      
      table[targetField] = table[currentField];
      table.Remove(currentField);
    }
  }
  
  public void ApplyConditional(DotConfig dotConfig) {
    if (ConditionalApplied)
      return;
    
    // Apply condition to self first
    this.ApplyConditionalOnOne(this.ConfigTable, dotConfig);
    
    foreach (object value in this.ConfigTable.Values) {
      if (value is not TomlTable)
        continue;
      this.ApplyConditionalOnOne((TomlTable) value, dotConfig);
    }
    
    ConditionalApplied = true;
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
