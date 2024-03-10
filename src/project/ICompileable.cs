namespace fox.foxie_flakey.uwumaker.project;

public interface ICompileableUnit {
  // Returns path to output if success or null if failed
  public Task<string?> Compile();
  
  // Cleans generated result
  public Task Clean();
  
  // If caller need to clear everything
  // (including caches of compilation)
  public async Task CleanSanitize() {
    await Clean();
  }
};
