{ lib }: {
  filterSources = prefix: lib.filterAttrs (n: v: lib.hasPrefix prefix n);
}
