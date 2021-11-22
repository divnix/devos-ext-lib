final: prev: {
  vscode-utils = prev.vscode-utils // (prev.callPackage ./src { });
  lib = prev.lib.extend (lfinal: lprev: { } // import ./src {
    lib = final.lib;
    vscode-utils = final.vscode-utils;
    vscode = final.vscode;
  });
}
