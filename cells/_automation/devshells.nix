{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) cells nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {
      extraModulesPath,
      pkgs,
      ...
    }: {
      name = "devos-ext-lib";

      git.hooks = {
        enable = true;
        pre-commit.text = builtins.readFile ./devshells/pre-flight-check.sh;
      };

      imports = [
        std.std.devshellProfiles.default
        "${extraModulesPath}/git/hooks.nix"
      ];

      packages = [
        # formatters
        nixpkgs.alejandra
      ];

      commands = with cell.lib.categories; [
        (formatters nixpkgs.treefmt)
        (formatters nixpkgs.editorconfig-checker)
        (legal nixpkgs.reuse)
        (utils {
          name = "evalnix";
          help = "Check Nix parsing";
          command = "${nixpkgs.fd}/bin/fd --extension nix --exec ${nixpkgs.nix}/bin/nix-instantiate --parse --quiet {} >/dev/null";
        })
        (utils cell.packages.repl)
      ];
    };

    checks = {...}: {
      name = "checks";
      imports = [std.std.devshellProfiles.default];
      commands = let
        tests = cells.std.lib.trimBy cells ["tests"];
        testToCommand = l.mapAttrsToList (otherCell: targets: let
          targetToTest =
            l.mapAttrsToList (targetName: value: {
              name = otherCell + "-" + targetName;
              command = l.concatStringsSep "; " [
                "echo -n '${value.description} \n  => '"
                (
                  if value.result == value.expected
                  then "echo 'PASSED!'"
                  else "echo 'FAILED! Run `nix develop .#devShells.${nixpkgs.system}.default --command repl` to inspect the problem. \n  => trace: Flake.${nixpkgs.system}.${otherCell}.tests.${targetName}'; export checks=1"
                )
              ];
            })
            targets;
        in
          targetToTest)
        tests;
        testCommands = l.flatten testToCommand;
        testNames = l.catAttrs "name" testCommands;
      in
        [
          {
            name = "run-all";
            command = l.concatStringsSep "; " (testNames
              ++ [
                "[[ -z \${checks+x} ]] && echo 'All tests passed!' || { echo 'Some tests failed!' && exit 1; }"
              ]);
          }
        ]
        ++ testCommands;
    };
  }
