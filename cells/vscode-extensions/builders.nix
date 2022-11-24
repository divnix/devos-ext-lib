{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) cells nixpkgs;
in {
  default = cell.builders.no-namespace;

  no-namespace = {
    srcs,
    vscode-utils ? nixpkgs.vscode-utils,
    libarchive ? nixpkgs.libarchive,
    vscodium ? nixpkgs.vscodium,
  }: let
    builder = extName: {
      src,
      version,
      name ? extName,
      publisher,
      meta ? {},
      ...
    } @ extArgs: let
      otherArguments =
        l.removeAttrs extArgs
        [
          "src"
          "pname"
          "name"
          "publisher"
          "version"
        ];

      drv = vscode-utils.buildVscodeMarketplaceExtension (l.flip l.recursiveUpdate otherArguments {
        vsix = src;
        mktplcRef = {inherit version name publisher;};
        buildInputs = [libarchive];
        unpackPhase = ''
          bsdtar xvf "$src" --strip-components=1 'extension/*'
        '';
        meta.platforms =
          if meta ? platforms
          then meta.platforms
          else vscodium.meta.platforms;
      });
    in
      l.nameValuePair (l.toLower extName) drv;
  in
    l.mapAttrs' builder srcs;

  with-namespace = {
    srcs,
    vscode-utils ? nixpkgs.vscode-utils,
    libarchive ? nixpkgs.libarchive,
    vscodium ? nixpkgs.vscodium,
  } @ args: let
    srcsByPublisher = l.groupBy (x: l.toLower x.publisher) (l.attrValues srcs);
    builder = publisher: exts:
      l.listToAttrs (l.map (value: {
          name = l.toLower value.name;
          inherit (cell.builders.no-namespace (args // {srcs = {inherit value;};})) value;
        })
        exts);
  in
    l.mapAttrs builder srcsByPublisher;
}
