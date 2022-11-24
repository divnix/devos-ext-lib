{
  inputs,
  cell,
}: let
  l = inputs.nixpkgs.lib // builtins;

  inherit
    (l)
    attrValues
    filterAttrs
    foldl'
    getAttrFromPath
    hasAttrByPath
    mapAttrs
    recursiveUpdate
    ;
in rec {
  # TODO: upstream the code to divnix/std
  # TODO: std lib documentation
  # TODO: better way to do these
  gather = cells: targets:
    filterAttrs
    (cell: organelle: hasAttrByPath targets organelle)
    cells;

  select = cells: targets:
    mapAttrs
    (cell: organelle: getAttrFromPath targets organelle)
    cells;

  trim = cells: targets: let
    selectors = trimBy cells targets;
  in
    foldl' recursiveUpdate {}
    (attrValues selectors);

  trimBy = cells: targets:
    select
    (
      gather cells targets
    )
    targets;
}
