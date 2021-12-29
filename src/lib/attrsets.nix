{ lib, attrsets }: attrsets // {
  dontFilterSources = _: sources: sources;

  filterSources = prefix: sources: lib.mapAttrs'
    (name: value:
      lib.nameValuePair
        (lib.removePrefix prefix name)
        value)
    (lib.filterAttrs
      (n: v: lib.hasPrefix prefix n)
      sources);
}