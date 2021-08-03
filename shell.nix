{ self, inputs, ... }:
{
  externalModules = with inputs; [
    bud.devshellModules.bud
  ];
}
