{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  repl = nixpkgs.writeShellScriptBin "repl" ''
    if [ -z "$1" ]; then
      nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" --file ${./packages/repl/repl.nix}
    else
      nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') --file ${./packages/repl/repl.nix} ''${@: 1}
    fi
  '';
}
