{ lib, filterSources, pkgBuilder, pkgSet }:

sources: { prefix ? "", ... }@overrides:

let

  filterSources' = overrides.filterSources or filterSources;

  pkgBuilder' = overrides.pkgBuilder or pkgBuilder;

  pkgSources = filterSources' prefix sources;

  pkgBuilderWithPrefix = pkgBuilder' prefix;

  pkgSet' = lib.mapAttrs' pkgBuilderWithPrefix pkgSources;

in pkgSet // pkgSet'
