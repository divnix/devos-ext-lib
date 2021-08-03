{ lib, vscode-utils }:
let
  inherit (lib)
    forEach
    getAttrs
    licenses
    maintainers
    optionalString
    toList
    ;
  inherit (vscode-utils)
    isVsix
    toJSONString
    ;
in
{
  mkVscodeExtMetaLicense = licenseStr:
    forEach
      (toList (builtins.fromJSON (toJSONString licenseStr)))
      (license: licenses."${license}");

  mkVscodeExtMetaLink = name: publisher: name: { openVsxPath ? "/", vscodeMarketplacePath ? "/" }:
    if isVsix name
    then "https://open-vsx.org/extension/${publisher}/${name}${openVsxPath}"
    else "https://marketplace.visualstudio.com/items/${publisher}.${name}${vscodeMarketplacePath}";

  mkVscodeExtMetaMaintainers = maintainersStr:
    forEach
      (toList (builtins.fromJSON maintainersStr))
      (maintainer: maintainers."${maintainer}");

  mkVscodeExtMetaOpt = ext:
    {
      homepage = ext.homepage or "";
      description = ext.description or "";
    };
}