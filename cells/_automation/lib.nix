{
  inputs,
  cell,
}: let
  l = inputs.nixpkgs.lib // builtins;

  cmdWithCategory = category: attrs: attrs // {inherit category;};

  pkgWithCategory = category: package: cmdWithCategory category {inherit package;};

  withCategory = category: attrs: let
    mapWith =
      if l.isDerivation attrs
      then pkgWithCategory
      else cmdWithCategory;
  in
    mapWith category attrs;

  mkCategories = categories: attrs: let
    withCategories = l.genAttrs categories (category: withCategory category);
  in
    withCategories // attrs;

  categories = [
    "cli-dev"
    "devos"
    "docs"
    "formatters"
    "legal"
    "utils"
  ];
in {
  categories = mkCategories categories {
    inherit cmdWithCategory pkgWithCategory withCategory categories;
  };
}
