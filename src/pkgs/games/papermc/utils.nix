{ lib
, pkgSet
, pkgSetUtils
, papermc

, jre8
, jre_headless
, adoptopenjdk-jre-openj9-bin-16
, javaPackages
}: pkgSetUtils // rec {
  # based on https://www.creeperhost.net/wiki/books/minecraft-java-edition/page/changing-java-versions
  mapMcJreVersion = mcVer: let
    isMcVer = mcVer': builtins.compareVersions mcVer mcVer' == -1;
  in
    if isMcVer "1.17" then jre8
    else if isMcVer "1.18" then adoptopenjdk-jre-openj9-bin-16
    else if isMcVer "1.19" then javaPackages.compiler.openjdk17.headless
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
        jre = mapMcJreVersion mcVer;
      }).overrideAttrs (_: source' // {
        passthru.mcVer = mcVer;
        version = "${mcVer}r${version}";
      });
    in lib.nameValuePair name papermc';
}