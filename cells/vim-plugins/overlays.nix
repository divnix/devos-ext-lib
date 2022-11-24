{
  inputs,
  cell,
}: {
  vimPlugins = inputs.cells.devos-ext-lib.lib.mkBuilderOverlay {
    pname = "vimUtils";
    inherit (cell) builders;
  };
}
