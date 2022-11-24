{
  inputs,
  cell,
}: {
  papermc = inputs.cells.devos-ext-lib.lib.mkBuilderOverlay {
    pname = "papermc";
    inherit (cell) builders;
  };
}
