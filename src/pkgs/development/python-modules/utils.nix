{ lib, pkgSet, pkgSetUtils, python3Packages }:
let
  meta = { };
in pkgSetUtils // {
  pkgBuilder = prefix: pname: { meta ? pkgSetUtils.meta or meta, doCheck ? false, ... }@source: let
    source' = builtins.removeAttrs source [ "pname" ];
    package = python3Packages.buildPythonPackage (source' // { inherit pname; });
  in lib.nameValuePair pname package;
}