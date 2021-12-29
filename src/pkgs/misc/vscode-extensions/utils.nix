{ lib, pkgSet, pkgSetUtils, vscode }:
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
      });
    in lib.nameValuePair name' ext;
  
  pkgBuilder' = prefix: publisher: sources:
    let
      pkgSet' = pkgSet."${publisher}" or { };
      exts = lib.foldl' (r: e:
        r // { "${lib.toLower e.name}" = (pkgBuilder prefix e.name e).value; }
      ) { } sources;
    in lib.nameValuePair (lib.toLower publisher) (pkgSet' // exts);
}