[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit] [![NixOS](https://img.shields.io/badge/NixOS-release--21.11-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

# Introduction

This is a kick ass library to dominate your Extensions (with [DevOS][devos]).

Currently [VS Code] extensions and some other package sets are supported. See also [flake.nix](./flake.nix).

# Usage

For now, let's use [VS Code] as an example.

Within `devos` itself, you can use as follow:

In `flake.nix`:
```nix
{
  inputs.devos-ext-lib.url = "github:divnix/devos-ext-lib";
  outputs = inputs@{ devos-ext-lib, ... }: digga.lib.mkFlake {
    channels.nixos.overlays = [ devos-ext-lib.overlays.vscode ];
  };
}
```

In `pkgs/default.nix`:
```nix
final: prev:
let
  sources = callPackage ./_sources/generated.nix { };
in {
  vscode-extensions = final.vscode-extensions-builder sources {
    # a function to merge previous extensions from a publisher
    # with new ones from `sources`
    # note: publisher and extension name are automatically converted
    #       to lower case
    pkgBuilder = final.vscode-utils.pkgBuilder';

    # a function that filters the sources by a prefix
    # and group them by their publishers (i.e. "${publisher}.${extension-name}")
    filterSources = final.lib.vscode-extensions.filterSources';

    # A typical nvfetcher toml:
    # [vscode-extensions-paulmolluzzo-convert-css-in-js]
    # src.manual = "0.3.0"
    # fetch.url = "https://open-vsx.org/api/paulmolluzzo/convert-css-in-js/0.3.0/file/paulmolluzzo.convert-css-in-js-0.3.0.vsix"
    # passthru = { publisher = "paulmolluzzo", name = "convert-css-in-js", description = "Convert kebab-case CSS to camelCase CSS and vice versa", license = "MIT" }
    #
    prefix = "vscode-extensions";
  };
}
```

It simply map through sources for VS Code extensions with `pkgBuilder`,
and you can override each extensions using //.

You can now refer to them as `pkgs.vscode-extensions.${publisher}.${extension-name}`,
such as `pkgs.vscode-extensions.paulmolluzzo.convert-css-in-js`.

## Metadata

For my personal use case, I use [openvsx-updater](https://github.com/danielphan2003/nixpkgs/blob/main/cells/nixpkgs/cli/updaters/openvsx.bash)
and more generally [danielphan2003/nixpkgs](https://github.com/danielphan2003/nixpkgs) to generate metadata automatically.

It uses GitHub Actions to fetch metadata from [OpenVSX], and [nvfetcher]
to get the sources and pass through the metadata for [VS Code] extensions.

Note that [VS Marketplace] extensions does not have a clear API for metadata extraction.
As a result, only [OpenVSX] ones are able to do so.

## TODOs:
- [ ] Documentation:
  - [ ] [minecraft-mods](./src/pkgs/misc/minecraft-mods)
  - [ ] [papermc](./src/pkgs/games/papermc)
  - [ ] [python3Packages](./src/pkgs/development/python-modules)
  - [ ] [vimPlugins](./src/pkgs/misc/vim-plugins)
  - [ ] [vscode-extensions](./src/pkgs/misc/vscode-extensions)
- [ ] Simplify API.
- [ ] Overlays or just plain `packages.${...}`?
- [ ] Tests for packaging extensions.

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
