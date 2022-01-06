{ stdenv
, lib
, pkgSet
, pkgSetUtils
, fd
, unzip
}:
let
  jars' = [
    ".*-SNAPSHOT.jar"
    ''.*[.*|\d+\.\d+\.\d+].jar''
    ".*[fabric|forge].*.jar"
  ];

  meta' = { };
in pkgSetUtils // {
  pkgBuilder =
    prefix: modName:
    { src
    , version

    , mcVer ? "any"

    , modId ? modName

    , meta ? pkgSetUtils.meta or meta'
    , jars ? pkgSetUtils.jars or jars'
    , ...
    }@source:
    let
      dontUnpack = lib.isJar src.name;
      mod = stdenv.mkDerivation {
        inherit src version dontUnpack;

        pname = "${prefix}-${modName}";

        passthru = { inherit mcVer modId; };

        nativeBuildInputs = [ fd ]
          ++ lib.optionals (!dontUnpack) [ unzip ];

        unpackPhase = lib.optionalString (!dontUnpack) ''
          unzip $src
        '';

        installPhase = ''
          mkdir -p $out/share/java

          ${if dontUnpack
            then "ln -s $src ."
            else "fd '.*dev|sources.jar' -X rm"}

          ${lib.concatMapStrings
            (e: ''
              fd '${e}' -x mv {} $out/share/java/${modName}-$version.jar
            '')
            jars}
        '';
      };
    in lib.nameValuePair modName mod;
}