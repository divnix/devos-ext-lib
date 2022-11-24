{
  inputs,
  cell,
}: {
  vscode-extensions = inputs.cells.devos-ext.lib.mkBuilderOverlay {
    pname = "vscode-utils";
    inherit (cell) builders;
  };
}
