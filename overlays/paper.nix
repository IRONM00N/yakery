final: prev: {
  papermc = prev.papermc.overrideAttrs (o: {
    src = prev.fetchurl {
      url = "https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/79/downloads/paper-1.21.4-79.jar";
      hash = "sha256-9FSZAhgn+nhwIuj5KXNnRHlVytgZA+k+RDD1twc9EdA=";
    };
  });
}
