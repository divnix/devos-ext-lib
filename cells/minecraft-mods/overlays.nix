{
  inputs,
  cell,
}: {
  minecraft-mods = inputs.cells.devos-ext-lib.lib.mkBuilderOverlay {
    pname = "minecraft-mods";
    inherit (cell) builders;
  };
}
