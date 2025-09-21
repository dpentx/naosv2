{
  description = "naos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, quickshell, ... }@inputs: {
    nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/hardware-configuration.nix
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.asus = {
            imports = [ ./home.nix ];
            _module.args = { inherit quickshell; };
          };
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
