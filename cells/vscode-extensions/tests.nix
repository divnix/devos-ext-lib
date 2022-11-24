{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;

  srcs = {
    arrterian-nix-env-selector = {
      pname = "arrterian-nix-env-selector";
      version = "1.0.9";
      src = nixpkgs.fetchurl {
        url = "https://open-vsx.org/api/arrterian/nix-env-selector/1.0.9/file/arrterian.nix-env-selector-1.0.9.vsix";
        sha256 = "sha256-KPVH74+gjDbjBLYtTOrTWEVcDB41oMn4cqK3/Yubhzs=";
      };
      name = "nix-env-selector";
      publisher = "arrterian";
      meta = {
        license = [l.licenses.mit];
        description = "Allows switch environment for Visual Studio Code and extensions based on Nix config file.";
      };
    };

    bbenoist-Nix = {
      pname = "bbenoist-Nix";
      version = "1.0.1";
      src = nixpkgs.fetchurl {
        url = "https://open-vsx.org/api/bbenoist/Nix/1.0.1/file/bbenoist.Nix-1.0.1.vsix";
        sha256 = "sha256-KaEd0ek/PtRQQ/jjiXO+sZ0hFqZAhFUE/gbN/NZwQoE=";
      };
      name = "Nix";
      publisher = "bbenoist";
      meta = {
        license = [l.licenses.mit];
        description = "Nix language support for Visual Studio Code.";
      };
    };
  };
in {
  no-namespace = {
    inherit srcs;

    description = "tests.vscode-extensions.no-namespace: can generate a package as \${publisher}-\${name}.";

    result = cell.builders.no-namespace {inherit srcs;};

    expected = let
      common = {
        buildInputs = [nixpkgs.libarchive];
        unpackPhase = ''
          bsdtar xvf "$src" --strip-components=1 'extension/*'
        '';
        meta.platforms = nixpkgs.vscodium.meta.platforms;
      };
      expectedBuilder = args: nixpkgs.vscode-utils.buildVscodeMarketplaceExtension (l.recursiveUpdate common args);
    in {
      arrterian-nix-env-selector = expectedBuilder {
        vsix = nixpkgs.fetchurl {
          url = "https://open-vsx.org/api/arrterian/nix-env-selector/1.0.9/file/arrterian.nix-env-selector-1.0.9.vsix";
          sha256 = "sha256-KPVH74+gjDbjBLYtTOrTWEVcDB41oMn4cqK3/Yubhzs=";
        };
        mktplcRef = {
          version = "1.0.9";
          name = "nix-env-selector";
          publisher = "arrterian";
        };
        meta = {
          license = [l.licenses.mit];
          description = "Allows switch environment for Visual Studio Code and extensions based on Nix config file.";
        };
      };
      bbenoist-nix = expectedBuilder {
        vsix = nixpkgs.fetchurl {
          url = "https://open-vsx.org/api/bbenoist/Nix/1.0.1/file/bbenoist.Nix-1.0.1.vsix";
          sha256 = "sha256-KaEd0ek/PtRQQ/jjiXO+sZ0hFqZAhFUE/gbN/NZwQoE=";
        };
        mktplcRef = {
          version = "1.0.1";
          name = "Nix";
          publisher = "bbenoist";
        };
        meta = {
          license = [l.licenses.mit];
          description = "Nix language support for Visual Studio Code.";
        };
      };
    };
  };

  with-namespace = {
    inherit srcs;

    description = "tests.vscode-extensions.with-namespace: can generate a package as \${publisher}.\${name}.";

    result = cell.builders.with-namespace {inherit srcs;};

    expected = l.mapAttrs' (n: v: let
      expectedPublisher = l.toLower v.publisher;
      expectedName = l.toLower v.name;
    in
      l.nameValuePair expectedPublisher {
        ${expectedName} = cell.tests.no-namespace.expected."${expectedPublisher}-${expectedName}";
      })
    srcs;
  };
}
