{
  description = "A kick ass library to dominate your Visual Studio Extensions (with DevOS)";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
      devshell.url = "github:numtide/devshell";
      flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixpkgs";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixpkgs";
      bud.inputs.devshell.follows = "digga/devshell";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      # and uncomment the poper lines using "utils/flake-utils" above
      flake-utils.url = "github:numtide/flake-utils";
      flake-utils-plus.inputs.flake-utils.follows = "flake-utils";
      # end ANTI CORRUPTION LAYER
    };

  outputs =
    { self
    , nixlib
    , nixpkgs
    , bud
    , devshell
    , flake-utils-plus
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