{ inputs, self, system ? builtins.currentSystem }:
let
  flatten' = builtins.foldl' (a: b: a ++ b) [ ];

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = { };
    overlays = flatten' (builtins.attrValues {
      inherit (self.overlays)
        vscode-extensions
        ;
    });
  };
in
{
  inherit (pkgs)
    lib

    vscode-extensions-builder
    vscode-utils
    ;
}
