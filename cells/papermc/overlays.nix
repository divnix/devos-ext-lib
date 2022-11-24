{
  inputs,
  cell,
}: {
  papermc = inputs.cells.devos-ext.lib.mkBuilderOverlay {
    pname = "papermc";
    inherit (cell) builders;
  };
}
