{
  config,
  pkgs,
  ...
}:{
  enable = true;

  policies = {
    DisablePocket = true;
    DisableTelemetry = true;
    FirefoxSuggest = builtins.toJSON {
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };
  };
}
