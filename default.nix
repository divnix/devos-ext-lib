{ inputs, self, system ? builtins.currentSystem }:
let
  flatten' = builtins.foldl' (a: b: a ++ b) [ ];

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = { };
    overlays = flatten' (builtins.attrValues {
      inherit (self.overlays)
        minecraft-mods
        papermc
        python3Packages
        vimPlugins
        vscode-extensions
        ;
    });
  };
in
{
  inherit (pkgs)
    lib

    minecraft-mods-builder
    minecraft-utils

    papermc-pkgs-builder
    papermc-utils

    python3Packages-builder
    python3Packages-utils

    vimPlugins-builder
    vimUtils

    vscode-extensions-builder
    vscode-utils
    ;
}
