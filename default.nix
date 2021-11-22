{ inputs, self, system ? builtins.currentSystem }:
let
  pkgs = import inputs.nixpkgs {
    inherit system; config = { };
    overlays = [
      self.overlay
    ];
  };
in
{
  inherit (pkgs)
    lib;
}
