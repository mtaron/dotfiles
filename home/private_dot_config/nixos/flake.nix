{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  inputs.atuin = {
    url = "github:atuinsh/atuin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    nixosConfigurations.nixos = import ./nixos.nix inputs;
  };
}
