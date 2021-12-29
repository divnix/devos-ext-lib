{
  description = "A kick ass library to extend your DevOS experience";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    };

  outputs =
    { self
    , nixpkgs
    , ...
    }@inputs:
    let
      # Unofficial Flakes Roadmap - Polyfills
      # .. see: https://demo.hedgedoc.org/s/_W6Ve03GK#
      # .. also: <repo-root>/ufr-polyfills
      # Super Stupid Flakes (ssf) / System As an Input - Style:
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      ufrContract = import ./ufr-polyfills/ufrContract.nix;
      # Dependency Groups - Style
      # .. we hope you like this style.
      # .. it's adopted by a growing number of projects.
      # Please consider adopting it if you want to help to improve flakes.

      makeExtLib = pkgSet: path: { pkgSetUtils ? "${pkgSet}-utils" }@attrs: [
        (import ./src/overlay.nix pkgSet path attrs)
      ] ++ nixpkgs.lib.optionals
        (builtins.pathExists "${path}/overlay.nix")
        [ "${path}/overlay.nix" ];
    in
    {
      lib.makeExtLib = makeExtLib;

      # what you came for ...
      packages = ufrContract supportedSystems ./. inputs self;

      overlays = {

        papermc = makeExtLib "papermc-pkgs" ./src/pkgs/games/papermc { };

        python3Packages = makeExtLib "python3Packages" ./src/pkgs/development/python-modules { };

        vscode-extensions = makeExtLib "vscode-extensions" ./src/pkgs/misc/vscode-extensions { pkgSetUtils = "vscode-utils"; };

      };
    };
}
