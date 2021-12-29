{ inputs, self, system ? builtins.currentSystem }:
let
  flatten' = builtins.foldl' (a: b: a ++ b) [ ];

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = { };
    overlays = flatten' (builtins.attrValues {
      inherit (self.overlays)
        python3Packages
        vscode-extensions
        ;
    });
  };
in
{
  inherit (pkgs)
    lib

    python3Packages-builder
    python3Packages-utils

    vscode-extensions-builder
    vscode-utils
    ;
}
