{ lib }: rec {
  inherit (lib) filterSources;

  filterSources' = prefix: sources:
    let
      sources' = filterSources prefix sources;
      publishers = lib.groupBy
        (source: source.publisher)
        (builtins.attrValues sources');
    in publishers;
}
