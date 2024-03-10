namespace fox.foxie_flakey.uwumaker.config;

using fox.foxie_flakey.uwumaker.project;

using Tomlyn.Model;
using System.Collections.Generic;

public class SubdirConfig : Config {
  public readonly Project ParentProject;
  public readonly IList<string> SourceFiles;
  
  // Only for root subdir
  public SubdirConfig(Project parentProject) : base(parentProject.ConfigPath, parentProject.Config.Get<TomlTable>("Subdir")) {
    this.ParentProject = parentProject;
    List<string> files = [];
    
    foreach (object? source in this.Get<IList<object>>("sources-c")) { 
      if (source is not string)
        throw new InvalidConfigException(this, "'Subdir.c-sources' array contains a non string entry");
      files.Add((string) source);
    }
    
    this.SourceFiles = files.AsReadOnly();
  }
}
