{
  description = "A kick ass library to dominate your Visual Studio Extensions (with DevOS)";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
      devshell.url = "github:numtide/devshell";
    };

  outputs =
    { self
    , nixpkgs
    , devshell
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
      devShellInputs = { inherit nixpkgs devshell; };
      # .. we hope you like this style.
      # .. it's adopted by a growing number of projects.
      # Please consider adopting it if you want to help to improve flakes.
    in

    {
      # what you came for ...
      overlay = import ./overlay.nix;
    };

}
