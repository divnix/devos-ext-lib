{ lib, pkgSet, pkgSetUtils, vim }:
let
  meta = { };
in pkgSetUtils // {
  pkgBuilder = prefix: pname: { meta ? pkgSetUtils.meta or meta, ... }@source: let
    source' = builtins.removeAttrs source [ "pname" ];
    plugin = pkgSetUtils.buildVimPluginFrom2Nix (source' // { inherit pname; });
  in lib.nameValuePair pname plugin;
}