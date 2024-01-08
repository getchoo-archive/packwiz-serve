{
  description = "a docker image to serve packwiz modpacks";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (sys: fn nixpkgs.legacyPackages.${sys});
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems ({
      pkgs,
      system,
      ...
    }: let
      containerFor = import ./container.nix pkgs;
      arch = pkgs.stdenv.hostPlatform.uname.processor;
    in {
      container-x86_64 = containerFor "x86_64";
      container-aarch64 = containerFor "aarch64";

      default = self.packages.${system}."container-${arch}";
    });
  };
}
