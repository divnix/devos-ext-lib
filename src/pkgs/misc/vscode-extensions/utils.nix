{ lib, pkgSet, pkgSetUtils, vscode, libarchive }:
let
  meta' = { inherit (vscode) platforms; };
in pkgSetUtils // rec {
  pkgBuilder = 
    prefix: name':
    { src
    , pname
    , version

    , name
    , publisher

    , meta ? pkgSetUtils.meta or meta'
    , ...
    }@source:
    let
      source' = builtins.removeAttrs source
        [
          "src"
          "pname"
          "name"
          "publisher"
          "version"
        ];
      ext = pkgSetUtils.buildVscodeMarketplaceExtension (source' // {
        vsix = src;
        mktplcRef = { inherit version name publisher; };
        buildInputs = [ libarchive ];
        unpackPhase = ''
          bsdtar xvf "$src" --strip-components=1 'extension/*'
        '';
      });
    in lib.nameValuePair (lib.toLower name') ext;
  
  pkgBuilder' = prefix: publisher: sources:
    let
      pkgSet' = pkgSet."${publisher}" or { };
      exts = lib.foldl' (r: e:
        let
          inherit (pkgBuilder prefix e.name e) name value;
        in r // { "${name}" = value; }
      ) { } sources;
    in lib.nameValuePair (lib.toLower publisher) (pkgSet' // exts);
}