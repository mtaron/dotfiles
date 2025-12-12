{
  nixpkgs,
  nixpkgs-unstable,
  atuin,
  ...
}:
let
  system = "x86_64-linux";
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    allowUnfree = true;
    allowAliases = false;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    { networking.hostName = "nixos"; }
    ./amd.nix
    ./nvidia.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./machine.nix
    (import ./unstable.nix { inherit pkgs-unstable; })
    { nixpkgs.overlays = [ atuin.overlays.default ]; }
  ];
}
