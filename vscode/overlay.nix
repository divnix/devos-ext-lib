final: prev: {
  vscode-utils = prev.vscode-utils // (prev.callPackage ./. { });
  lib = prev.lib.extend (lfinal: lprev: { } // import ./. {
    inherit (final) lib vscode-utils vscode;
  });
}
