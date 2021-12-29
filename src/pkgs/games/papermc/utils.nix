{ lib
, pkgSet
, pkgSetUtils
, papermc

, jre8
, jre_headless
, javaPackages
}: pkgSetUtils // rec {
  # based on https://www.creeperhost.net/wiki/books/minecraft-java-edition/page/changing-java-versions
  mapMcJreVersion = mcVer: let
    cmpMcVer = builtins.compareVersions mcVer;
  in
    if cmpMcVer "1.17" == -1 then jre8
    else if cmpMcVer "1.18" == -1 then javaPackages.compiler.openjdk16.headless
    else if cmpMcVer "1.19" == -1 then javaPackages.compiler.openjdk17.headless
    else jre_headless;

  pkgBuilder =
    prefix: name:
    { src
    , pname
    , version

    , mcVer

    , meta ? pkgSetUtils.meta or papermc.meta
    , ...
    }@source:
    let
      source' = builtins.removeAttrs source
        [
          "pname"
          "version"
        ];
      papermc' = (papermc.override { 
        jre = mapMcJreVersion mcVer { };
      }).overrideAttrs (_: source' // {
        passthru.mcVer = mcVer;
        version = "${mcVer}r${version}";
      });
    in lib.nameValuePair name papermc';
}