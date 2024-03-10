namespace fox.foxie_flakey.uwumaker.project;

public interface ICompileableUnit {
  // Returns true if success or false if failed
  public Task<bool> Compile();
  
  // Cleans generated result
  public Task Clean();
  
  // If caller need to clear everything
  // (including caches of compilation)
  public async Task CleanSanitize() {
    await Clean();
  }
};
