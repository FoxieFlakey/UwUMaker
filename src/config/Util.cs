namespace fox.foxie_flakey.uwumaker.config;

using System.Globalization;
using System.Text.RegularExpressions;
using Tomlyn.Model;

public partial class Util {
  public static TomlTable ApplyConditional(TomlTable table, DotConfig dotConfig) {
    Queue<TomlTable> queue = new(100);
    queue.Enqueue(table);
    while (queue.Count > 0) {
      TomlTable current = queue.Dequeue();
      Util.ApplyConditionalOnOne(current, dotConfig, queue);
    }
    
    return table;
  }
  
  [GeneratedRegex("^(.+)[-]CONFIG_(.+?)$")]
  private static partial Regex ConditionalKeyMatchRegex();
  private static void ApplyConditionalOnOne(TomlTable table, DotConfig dotConfig, Queue<TomlTable> queueOfTables) {
    List<string> toBeRemoved = [];
    
    // Apply the conditions
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
      
      DoReplace(dest: targetField, src: currentKey);
      toBeRemoved.Add(currentKey);
    }
   
    void DoReplace(string dest, string src) {
      if (table[src] is not TomlArray) {
        table[dest] = table[src];
        return;
      }
      
      // So if array, then append
      foreach (var item in (TomlArray) table[src])
        ((TomlArray) table[dest]).Add(item);
    } 
    
    // Remove the condition fields
    foreach (var key in toBeRemoved) {
      table.Remove(key);
    }
  }
}
