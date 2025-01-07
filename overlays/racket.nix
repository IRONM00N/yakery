final: prev: {
  racket = prev.racket.overrideAttrs (oldAttrs: rec {
    version = "8.15";
    src = prev.fetchurl {
      url = "https://mirror.racket-lang.org/installers/${version}/racket-${version}-src.tgz";
      hash = "sha256-YCuEhFna8bIiKkapCU6Fri0o5IAGchmVf6Rq+EAOEjM=";
    };
  });
}
