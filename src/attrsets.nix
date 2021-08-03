{ lib, vscode-utils }:
let
  inherit (lib)
    getName
    head
    init
    last
    splitString
    ;
  inherit (vscode-utils)
    isVsix
    ;
in
{
  mkVscodeExtUniqueId =
    src:
    let
      matchOpenvsxId = splitString ".";
      matchVsmarketplaceId = url: init
        (builtins.match
          # 1st & 2nd match: publisher
          # 3rd match: name
          # 4th match: version (ignored by init)
          "https://(.*).gallery.vsassets.io/_apis/public/gallery/publisher/(.*)/extension/(.*)/(.*)/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
          url);
      uniqueIds =
        if isVsix src.name
        then matchOpenvsxId (getName src.name)
        else matchVsmarketplaceId (head src.urls);
    in
    { publisher = head uniqueIds; name = last uniqueIds; };
}