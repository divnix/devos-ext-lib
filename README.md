[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit] [![NixOS](https://img.shields.io/badge/NixOS-release--21.11-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

# Introduction

This is a kick ass library to dominate your Extensions (with [DevOS][devos]).

Currently [VS Code] extensions are supported. PRs for others
(e.g Vim, Atom, etc.) are welcome.

# Usage

For now, let's use [VS Code] as an example.

Within `devos` itself, you can use as follow:

In `flake.nix`:
```nix
{
  inputs.devos-ext-lib.url = "github:divnix/devos-ext-lib";
  outputs = inputs@{ devos-ext-lib, ... }: digga.lib.mkFlake {
    channels.nixos.overlays = [ devos-ext-lib.overlay.vscode ];
  };
}
```

In `pkgs/default.nix`:
```nix
final: prev:
let
  sources = callPackage ./_sources/generated.nix { };
in {
  vscode-extensions = prev.vscode-extensions // (final.lib.vscodePkgsSet "vscode-extensions" sources);
}
```

This gives us auto-generated VS Code extensions, and you can override each
extensions via overlays.

## Metadata

You can use [`bud/vscode-ext-prefetch.bash`](./bud/vscode-ext-prefetch.bash)
with [nvfetcher] to generate metadata for [VS Code] extensions. Note that
[VS Marketplace] extensions does not have a clear API for metadata extraction.
As a result, only [OpenVSX] ones are able to do so.

See also [`src/vscode/generators.nix`](./src/vscode/generators.nix#L34) for
a detailed overview.

As [nvfetcher] generates nix sources expr for packages including extensions,
it should also generate extensions' metadata as well.
Feel free to open an issue to discuss about this.

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

## Things that would really improve the quality of this work
- Tests for packaging extensions.
- Conventional naming for extensions.
  - [VS Code]: `vscode-extensions.${author}.${ename}` (use by [nixpkgs]) or `vscode-extensions-${ename}` (use by devos-ext-lib)

[mit]: https://mit-license.org

[devos]: https://github.com/divnix/devos

[VS Code]: https://code.visualstudio.com
[VS Marketplace]: https://marketplace.visualstudio.com/vscode
[OpenVSX]: https://open-vsx.org

[fu]: https://github.com/numtide/flake-utils
[fup]: https://github.com/gytis-ivaskevicius/flake-utils-plus
[giants]: https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants
[devshell]: https://github.com/numtide/devshell
[nixpkgs]: https://github.com/NixOS/nixpkgs
[nvfetcher]: https://github.com/berberman/nvfetcher
