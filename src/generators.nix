{ lib
, vscode
, vscode-utils
}:
let
  inherit (lib)
    asserts
    maintainers;
  inherit (vscode-utils)
    mkVscodeExtMetaLink
    mkVscodeExtMetaLicense
    mkVscodeExtMetaMaintainers
    mkVscodeExtMetaOpt
    mkVscodeExtUniqueId
    ;
in
{
  mkVscodeExtension = ext:
    let
      mktplcRef = mkVscodeExtUniqueId ext.src;
    in
    { name ? mktplcRef.name
    , publisher ? mktplcRef.publisher
    }:
    vscode-utils.extensionFromVscodeMarketplace {
      inherit (ext) version;

      inherit publisher name;

      vsix = "${publisher}-${name}.zip";

      preUnpack = ''ln -s "${ext.src}" $src'';

      meta = {
        changelog = mkVscodeExtMetaLink ext.src.name publisher name {
          openVsxPath = "/changes";
          vscodeMarketplacePath = "/changelog";
        };
        downloadPage = mkVscodeExtMetaLink ext.src.name publisher name { };
        license = assert asserts.assertMsg (ext ? license) "Specify a license for ${publisher}.${name} VS Code extension!";
          mkVscodeExtMetaLicense ext.license;
        maintainers =
          if ext ? maintainers
          then mkVscodeExtMetaMaintainers ext.maintainers
          else [ maintainers.danielphan2003 ];
        inherit (vscode.meta) platforms;
        inherit (mkVscodeExtMetaOpt ext) homepage description;
      };
    };
}