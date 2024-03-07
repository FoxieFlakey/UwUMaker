namespace fox.foxie_flakey.uwumaker.project.config {
  public class InvalidConfigException(Config config, string reason)
      : Exception(reason) {
    public Config Config = config;
  }
  
  public class MissingConfigKeyException(Config config, string reason)
      : InvalidConfigException(config, reason) {
  }
  
  public class InvalidConfigValueException(Config config, string reason)
      : InvalidConfigException(config, reason) {
  }
}
