{ lib }:
let
  inherit (lib) hasPrefix hasSuffix;

  isNaiveJSONList = str: (hasPrefix "[" str) && (hasSuffix "]" str);

  isVsix = hasSuffix ".vsix";

  isVsixPackage = hasSuffix ".VSIXPackage";

  isVscodeExt = name: (isVsix name) || (isVsixPackage name);

  toJSONString = str:
    if isNaiveJSONList str
    then str
    else ''"${str}"'';
in
{
  inherit
    isNaiveJSONList
    isVscodeExt
    isVsix
    isVsixPackage
    toJSONString
    ;
}