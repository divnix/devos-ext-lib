{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
in {
  default = {
    srcs,
    python3Packages ? nixpkgs.python3Packages,
  } @ args: let
    builder = pname': {
      pname ? pname',
      doCheck ? false,
      ...
    } @ pArgs:
      python3Packages.buildPythonPackage pArgs;
  in
    l.mapAttrs builder srcs;
}
