{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;

  srcs = {
    ferret = {
      pname = "ferret";
      version = "2022-06-12";
      src = nixpkgs.fetchFromGitHub {
        owner = "wincent";
        repo = "ferret";
        rev = "3d064304876941e4197db6b4264db6b72bd9f83d";
        fetchSubmodules = false;
        sha256 = "1lkznmavw2f4ckh3yjjvdhja313ia0aayn5pkf6ygjny1089gcih";
      };
      meta.homepage = "https://github.com/wincent/ferret/";
    };
    yuck = {
      pname = "yuck";
      version = "6dc3da77c53820c32648cf67cbdbdfb6994f4e08";
      src = nixpkgs.fetchFromGitHub {
        owner = "elkowar";
        repo = "yuck.vim";
        rev = "6dc3da77c53820c32648cf67cbdbdfb6994f4e08";
        fetchSubmodules = false;
        sha256 = "sha256-lp7qJWkvelVfoLCyI0aAiajTC+0W1BzDhmtta7tnICE=";
      };
    };
  };
in {
  default = {
    inherit srcs;
    description = "tests.vim-plugins.default: can generate a package from source.";
    result = cell.builders.default {inherit srcs;};
    expected = l.mapAttrs (_: nixpkgs.vimUtils.buildVimPluginFrom2Nix) srcs;
  };
}
