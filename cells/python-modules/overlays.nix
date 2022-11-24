{
  inputs,
  cell,
}: {
  python3Packages = inputs.cells.devos-ext.lib.mkBuilderOverlay {
    pname = "python3Packages";
    inherit (cell) builders;
  };
}
