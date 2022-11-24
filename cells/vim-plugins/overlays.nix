{
  inputs,
  cell,
}: {
  vimPlugins = inputs.cells.devos-ext.lib.mkBuilderOverlay {
    pname = "vimUtils";
    inherit (cell) builders;
  };
}
