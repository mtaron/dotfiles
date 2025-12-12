{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  inputs.atuin = {
    url = "github:atuinsh/atuin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      atuin,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = [ atuin.overlays.default ]; }
        ];
      };
    };
}
