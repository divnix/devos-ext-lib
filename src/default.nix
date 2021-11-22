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
    mkVscodeExtensions
    mkVscodeExtensions'
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
}
