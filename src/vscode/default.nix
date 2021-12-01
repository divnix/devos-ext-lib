{ lib, vscode, vscode-utils }:
let
  attrsets = import ./attrsets.nix { inherit lib vscode-utils; };
  generators = import ./generators.nix { inherit lib vscode vscode-utils; };
  meta = import ./meta.nix { inherit lib vscode-utils; };
  strings = import ./strings.nix { inherit lib; };
in
rec {
  inherit (attrsets)
    mkVscodeExtUniqueId
    ;

  inherit (generators)
    mkVscodeExtension
    ;

  inherit (meta)
    mkVscodeExtMetaLicense
    mkVscodeExtMetaLink
    mkVscodeExtMetaMaintainers
    mkVscodeExtMetaOpt
    ;

  inherit (strings)
    isNaiveJSONList
    isVscodeExt
    isVsix
    isVsixPackage
    toJSONString
    ;



  vscodePkgsSet = pkgSet: sources:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vscode-extensions" = extension: vscode-utils.mkVscodeExtension extension { };
      }."${pkgSet}";
      pkgsInSources = lib.mapAttrs' (name: lib.nameValuePair (lib.removePrefix prefix name)) (lib.filterAttrs (n: v: lib.hasPrefix prefix n) sources);
    in
    lib.mapAttrs (n: pkgSetBuilder) pkgsInSources;
}
