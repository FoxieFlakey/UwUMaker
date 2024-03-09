namespace fox.foxie_flakey.uwumaker.config;

public class InvalidConfigException(Config config, string reason)
    : Exception($"In '{config.Path}' config: " + reason) {
  public Config Config = config;
}

public class MissingConfigKeyException(Config config, string reason)
    : InvalidConfigException(config, reason) {
}

public class InvalidConfigValueException(Config config, string reason)
    : InvalidConfigException(config, reason) {
}

