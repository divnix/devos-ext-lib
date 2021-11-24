let
  eachSystem = import ./eachSystem.nix;
in

supportedSystems:
imprt: inputs: self:
eachSystem supportedSystems (system:
  import imprt {
    inherit inputs system self; # The super stupid flakes contract `{ inputs, system }`
  }
)
