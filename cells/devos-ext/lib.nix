{
  inputs,
  cell,
}: let
  l = inputs.nixpkgs.lib // builtins // cell.lib;
in {
  /*
  A function that do nothing with any given attributes.

  The transformation is: src.* -> src.*

  You can typically use this function when you don't want to
  filter out any attributes, such as when providing `src` an attribute set
  that has already been filtered.
  Example:
  ```nix
  # src
  {
    packagesA-helper1 = ...;
    packagesA-helper2 = ...;
    packagesB = ...;
  }
  # dontFilterSrc src
  {
    packagesA-helper1 = ...;
    packagesA-helper2 = ...;
    packagesB = ...;
  }
  */
  dontFilterSrc = _: l.id;

  /*
  A function that filters out any attributes that doesn't match `prefix`.

  The transformation is: src.* -> src.prefix^

  You can typically use this function when composing a packages builder
  with `mkPackagesBuilder`.
  Example:
  ```nix
  # src
  {
    packagesA-helper3 = ...;
    packagesA-helper4 = ...;
    packagesB = ...;
  }
  # filterSrc "packagesA-" src
  {
    packagesA-helper3 = ...;
    packagesA-helper4 = ...;
  }
  ```
  */
  filterSrc = prefix:
    l.filterAttrs
    (name: _: l.hasPrefix prefix name);

  /*
  A function that filters out any attributes that doesn't match `prefix`,
  and removes `prefix` from its attribute names.

  The transformation is: src.* -> src.prefix^ -> src.^

  You can typically use this function when composing a packages builder
  with `mkPackagesBuilder`.
  Example:
  ```nix
  # src
  {
    packagesA-helper3 = ...;
    packagesA-helper4 = ...;
    packagesB = ...;
  }
  # filterSrc' "packagesA-" src
  {
    helper3 = ...;
    helper4 = ...;
  }
  ```
  */
  filterSrc' = prefix: src: let
    matches = l.filterSrc prefix src;
    removePrefix = name: l.nameValuePair (l.removePrefix prefix name);
  in
    l.mapAttrs' removePrefix matches;

  /*
  A function that returns an overlay that injects a builder's library to `pkgs.lib` and `lib`
  as `pkgs.lib.${args.pname}` and `lib.${args.pname}`

  The transformation is: args -> final: prev: <an attribute containing the injected `lib`>

  `args` is an argument with the following attributes:
  {
    pname = string;
    lib = attrs;
  }

  Example:
  ```nix
  # args
  {
    pname = "packagesA";
    lib = {
      builder = <function>;
      builders = {
        default = <function>;
        ...;
      };
      ...;
    };
  }
  # mkBuilderOverlay args
  final: prev: {
    lib = prev.lib.extends (lfinal: lprev: {
      packagesA = {
        builder = <function>;
        builders = {
          default = <function>;
          ...;
        };
        ...;
      };
    });
  }
  ```
  */
  mkBuilderOverlay = {
    pname,
    builders,
  }: final: prev: {
    lib = prev.lib.extend (lfinal: lprev: {
      ${pname} = {inherit builders;};
    });
  };
}
