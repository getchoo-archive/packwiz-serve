{
  lib,
  pkgs,
  system,
  ...
}: arch: let
  crossPkgs =
    {
      "x86_64-linux" = {
        "x86_64" = pkgs.pkgsStatic;
        "aarch64" = pkgs.pkgsCross.aarch64-multiplatform.pkgsStatic;
      };

      "aarch64-linux" = {
        "x86_64" = pkgs.pkgsCross.musl64;
        "aarch64" = pkgs.pkgsStatic;
      };
    }
    .${system}
    .${arch};

  packwiz = crossPkgs.packwiz.overrideAttrs (oldAttrs: {
    ldflags = [
      "-linkmode external"
      "-extldflags '-static -L${crossPkgs.musl}/lib'"
      "-s -w -X github.com/packwiz/packwiz.version=${oldAttrs.version}"
    ];

    postInstall = "";

    CGO_ENABLED = 0;
  });
in
  pkgs.dockerTools.buildLayeredImage {
    name = "packwiz-serve";
    tag = "latest-${arch}";

    contents = [packwiz];

    config = {
      Cmd = ["/bin/packwiz" "serve"];
      Env = [
        "HOME=/home" # why exactly does packwiz need a home dir? :shrug:
      ];
      WorkingDir = "/data";
      Volumes = {"/data" = {};};
      ExposedPorts = {"8080" = {};};
    };

    architecture = crossPkgs.go.GOARCH;
  }
