final: prev: {
  vscode-utils = prev.vscode-utils // (prev.callPackage ./. { });
  lib = prev.lib.extend (lfinal: lprev: { } // import ./. {
    lib = final.lib;
    vscode-utils = final.vscode-utils;
    vscode = final.vscode;
  });
}
