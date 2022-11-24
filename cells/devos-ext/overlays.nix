{
  inputs,
  cell,
}: {
  default = final: prev: {
    lib = prev.lib.extend (lfinal: lprev: {
      devos-ext = cell.lib;
    });
  };
}
