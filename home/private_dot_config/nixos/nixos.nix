{
  nixpkgs,
  atuin,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    { networking.hostName = "nixos"; }
    ./configuration.nix
    ./hardware-configuration.nix
    ./machine.nix
    { nixpkgs.overlays = [ atuin.overlays.default ]; }
  ];
}
