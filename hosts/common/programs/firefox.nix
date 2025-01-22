{ pkgs }:
{
  enable = true;
  # see about:policies#documentation
  policies = {
    DisablePocket = true;
    DisableTelemetry = true;
    FirefoxSuggest = {
      "WebSuggestions" = true;
      "SponsoredSuggestions" = false;
      "ImproveSuggest" = false;
      "Locked" = false;
    };
    FirefoxHome = {
      "Search" = true;
      "TopSites" = false;
      "SponsoredTopSites" = false;
      "Pocket" = false;
      "SponsoredPocket" = false;
      "Locked" = false;
    };
  };
}
