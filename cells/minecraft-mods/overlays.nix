{
  inputs,
  cell,
}: {
  minecraft-mods = inputs.cells.devos-ext.lib.mkBuilderOverlay {
    pname = "minecraft-mods";
    inherit (cell) builders;
  };
}
