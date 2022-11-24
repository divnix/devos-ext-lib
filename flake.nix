{
  description = "A kick ass library to extend your DevOS experience";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    std,
    ...
  } @ inputs: let
    l = nixpkgs.lib // builtins // self.lib;

    # exports have no system, pick one
    exports' = "x86_64-linux";
    exports = inputs.self."${exports'}";
  in
    std.growOn {
      inherit inputs;

      cellsFrom = ./cells;

      cellBlocks = with std.blockTypes; [
        # builders to make package sets
        (functions "builders")

        # devshells can be entered
        (devshells "devshells")

        # library holds shared knowledge made code
        (functions "lib")

        # packages can be installed
        (functions "packages")

        # overlays
        (functions "overlays")

        # tests
        (functions "tests")
      ];
    } {
      devShells = std.harvest self ["_automation" "devshells"];

      # get all cells with `lib` target, and merge it into a single attrset
      lib = let
        # bootstrapping lib from cells.std.lib
        std.lib = inputs.std.harvest self ["std" "lib"];
      in
        std.lib."${exports'}".trimBy exports ["lib"];

      # overlays
      overlays = l.std.trim exports ["overlays"];
    };

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://fog.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fog.cachix.org-1:FAxiA6qMLoXEUdEq+HaT24g1MjnxdfygrbrLDBp6U/s="
    ];
  };
  # --------------------------------------------------------------
}
