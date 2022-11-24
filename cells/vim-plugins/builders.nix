{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
in {
  default = {
    srcs,
    vimUtils ? nixpkgs.vimUtils,
  }: let
    builder = fallbackPname: {pname ? fallbackPname, ...} @ pArgs:
      vimUtils.buildVimPluginFrom2Nix pArgs;
  in
    l.mapAttrs builder srcs;
}
