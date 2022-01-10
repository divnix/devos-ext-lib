pkgSet: path: { pkgSetUtils ? "${pkgSet}-utils" }:

final: prev:
{
  "${pkgSetUtils}" = final.callPackage "${path}/utils.nix" {
    pkgSet = prev."${pkgSet}" or { };
    pkgSetUtils = prev."${pkgSetUtils}" or { };
  };

  lib = prev.lib.extend (lfinal: lprev: let lib = lfinal; in {
    attrsets = import ./lib/attrsets.nix {
      inherit lib;
      inherit (lprev) attrsets;
    };

    "${pkgSet}" = import "${path}/lib.nix" { inherit lib; };

    inherit (lfinal.attrsets)
      dontFilterSources
      filterSources
      ;
  });

  "${pkgSet}-builder" = import ./. {
    inherit (final) lib;
    inherit (final.lib."${pkgSet}") filterSources;
    inherit (final."${pkgSetUtils}") pkgBuilder;
    pkgSet = prev."${pkgSet}" or { };
  };
}
