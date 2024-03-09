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
  private void ApplyConditionalOnOne(TomlTable table, DotConfig dotConfig, Queue<TomlTable> queueOfTables) {
    foreach (var current in table) {
      string currentKey = current.Key;
      
      if (current.Value is TomlTable innerTable)
        queueOfTables.Enqueue(innerTable);
      
      // Match the key specially named like name-CONFIG_BLAH
      IList<Match> match = ConditionalKeyMatchRegex().Matches(currentKey);
      if (match.Count == 0)
        continue;
      
      string targetField = match[0].Groups[1].Value;
      string configKey = match[0].Groups[2].Value;
      
      // The corresponding config key isn't enabled
      // or missing so skip
      if (!dotConfig.ContainsKey(configKey) || !dotConfig.GetBool(configKey))
        continue;
      
      table[targetField] = table[currentKey];
      table.Remove(currentKey);
    }
  }
  
  public void ApplyConditional(DotConfig dotConfig) {
    if (ConditionalApplied)
      return;
    
    Queue<TomlTable> queue = new(100);
    queue.Enqueue(this.ConfigTable);
    while (queue.Count > 0) {
      TomlTable current = queue.Dequeue();
      this.ApplyConditionalOnOne(current, dotConfig, queue);
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
