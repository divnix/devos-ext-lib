{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
in {
  default = {
    srcs,
    prefix ? "minecraft-mod",
    stdenv ? nixpkgs.stdenv,
    fd ? nixpkgs.fd,
    unzip ? nixpkgs.unzip,
  }: let
    builder = modName: {
      src,
      version,
      compatibility ? "any",
      id ? modName,
      meta ? {},
      matchers ? [
        ".*-SNAPSHOT.jar"
        ''.*[.*|\d+\.\d+\.\d+].jar''
        ".*[fabric|forge].*.jar"
      ],
      ...
    } @ modArgs: let
      otherArguments =
        l.removeAttrs modArgs
        [
          "compatibility"
          "id"
          "matchers"
        ];
    in
      stdenv.mkDerivation (final:
        l.flip l.recursiveUpdate otherArguments {
          dontUnpack = l.hasSuffix ".jar" src.name;

          pname = prefix + "-" + modName;

          nativeBuildInputs =
            [fd]
            ++ l.optionals (!final.dontUnpack) [unzip];

          unpackPhase = l.optionalString (!final.dontUnpack) ''
            unzip "$src"
          '';

          installPhase = ''
            mkdir -p "$out/share/java"
            ${
              if final.dontUnpack
              then ''ln -s "$src" .''
              else "fd '.*dev|sources.jar' -X rm"
            }
            ${l.concatMapStrings
              (e: ''
                fd '${e}' -x mv {} "$out/share/java/${modName}-$version.jar"
              '')
              matchers}
          '';

          passthru = {
            minecraft = {inherit compatibility;};
            modrinth.id = l.mkIf (id != modName) id;
          };
        });
  in
    l.mapAttrs builder srcs;
}
