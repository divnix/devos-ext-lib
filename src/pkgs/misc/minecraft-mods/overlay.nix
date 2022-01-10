final: prev:
{
  lib = prev.lib.extend (lfinal: lprev: let lib = lfinal; in {
    inherit (lib.minecraft-mods)
      isJar
      ;
  });
}
