{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
in {
  default = {
    srcs,
    papermc ? nixpkgs.papermc,
    pkgs,
  }: let
    builder = pname: {
      src,
      version,
      mcVersion,
      meta ? papermc.meta,
      ...
    } @ pArgs: let
      otherArguments = l.removeAttrs pArgs [
        "pname"
        "version"
      ];

      drvOverride = papermc.override {
        jre = pkgs."${cell.lib.jreMcVersion mcVersion}";
      };
    in
      drvOverride.overrideAttrs (_:
        l.flip l.recursiveUpdate otherArguments {
          passthru.mcVer = mcVersion;
          version = "${mcVersion}r${version}";
        });
  in
    l.mapAttrs builder srcs;
}
