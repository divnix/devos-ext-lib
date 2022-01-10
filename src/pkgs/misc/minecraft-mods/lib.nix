{ lib }: {
  inherit (lib) filterSources;

  isJar = lib.hasSuffix ".jar";
}
