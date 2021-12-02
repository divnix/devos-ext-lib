[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit] [![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

# Notice
This is alpha quality at most. There are still some rough revision to be made, especially since the [author][danielphan2003] have somewhat eligible capacity to pull this off.

In the meantime, check out [devos][devos] for more interesting use of Nix.

# Usage

Within `devos` itself, you can use as follow:

In `flake.nix`:
```nix
{
  inputs.devos-ext-lib.url = "github:divnix/devos-ext-lib";
  outputs = inputs@{ devos-ext-lib, ... }: digga.lib.mkFlake {
    channels.nixos.overlays = [ devos-ext-lib.overlay.vscode ];
  };
};
```

In `pkgs/default.nix`:
```nix
final: prev:
let
  sources = callPackage ./_sources/generated.nix { };
in
  vscode-extensions = prev.vscode-extensions // (final.lib.vscodePkgsSet "vscode-extensions" sources);
}
```
(wait for [this PR][automatically-build-source] to merge as it is the same as the above, just remember that the PR was for `vimPlugins`, so adjust accordingly).

This gives us auto-generated VS Code extensions with `meta` attributes. See [`src/generators.nix`](./src/generators.nix#L34) for a detailed overview.

## Helper scripts a.k.a `devshell`
You can use [`bud/vscode-ext-prefetch.bash`](./bud/vscode-ext-prefetch.bash) to generate sources and metadata passthrough for extensions. Note that support for VS Marketplace extensions is not yet available as I could only find APIs for OpenVSX.

And no, there aren't any `devshell` yet. See below for details.

## Shoulders
This work does not reinvent the wheel. It stands on the [shoulders of the
following giants][giants]:

### :onion: &mdash; like the layers of an onion
- [`divnix/devos`][devos]
- [`gytis-ivaskevicius/flake-utils-plus`][fup]
- [`numtide/flake-utils`][fu]

### :family: &mdash; like family
- [`numtide/devshell`][devshell]
- [`berberman/nvfetcher`][nvfetcher]
- [`NixOS/nixpkgs`][nixpkgs]

:heart:

### Things that would really improve the quality of this work
- `devshell` (obviously, but [`bud`][bud] is still experimental, so documentations seem vague, or maybe I just got lazy).
- More intuitive arrangement of [`src`](./src). This is a mess I created from `lib` and `vscode-utils`, so I really hope to separate them appropriately.
- Maybe a template or at least a guideline for creating projects like this in the future? This whole project is already small, but I still can't grasp some of the core concepts. With a little of extra helps, maybe I can really pull this one off for real.

Over time, this will improve, just not right now (I might get overwhelmed as this is my first time ever contributing and managing a repository, but it won't stop me from making progress).

[mit]: https://mit-license.org
[danielphan2003]: https://github.com/danielphan2003

[devos]: https://github.com/divnix/devos

[automatically-build-source]: https://github.com/divnix/devos/pull/348

[fu]: https://github.com/numtide/flake-utils
[fup]: https://github.com/gytis-ivaskevicius/flake-utils-plus
[giants]: https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants
[devshell]: https://github.com/numtide/devshell
[nixpkgs]: https://github.com/NixOS/nixpkgs
[nvfetcher]: https://github.com/berberman/nvfetcher

[bud]: https://github.com/divnix/bud
