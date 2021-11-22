final: prev: {
  vscode-utils = prev.vscode-utils // (prev.callPackage ./src { });
  lib = prev.lib.extend (lfinal: lprev: { } // import ./src/lib.nix {
    lib = final.lib;
    vscode-utils = final.vscode-utils;
  });
}
