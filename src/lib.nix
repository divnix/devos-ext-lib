{ lib, vscode-utils }:
let
  mkVscodeExtension' = extension: vscode-utils.mkVscodeExtension extension { };
in
{
  vscodePkgsSet = pkgSet: sources:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vscode-extensions" = mkVscodeExtension';
      }.${pkgSet};
      pkgsInSources = lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix prefix name) (value)) (lib.filterAttrs (n: v: lib.hasPrefix prefix n) sources);
    in
    lib.mapAttrs (n: v: pkgSetBuilder v) pkgsInSources;
}
