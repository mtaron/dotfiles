{
  nixpkgs,
  atuin,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    { nixpkgs.overlays = [ atuin.overlays.default ]; }
  ];
}
