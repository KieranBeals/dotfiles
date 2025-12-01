{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-25.05";
		# Really just importing just to import stuff at this point lmao
    systems.url = "github:nix-systems/default-linux";

    # flake-compat = {
    #   url = "github:edolstra/flake-compat";
    # };

    # flake-utils = {
    #   url = "github:numtide/flake-utils";
    #   inputs.systems.follows = "systems";
    # };

    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # git-hooks-nix = {
    #   url = "github:cachix/git-hooks.nix";
    #   inputs = {
    #     flake-compat.follows = "flake-compat";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		# Programs
		neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		helium-browser = {
		  url = "github:FKouhai/helium2nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    # lanzaboote.url = "github:nix-community/lanzaboote";

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		gotcha = {
      url = "github:MrSom3body/gotcha";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index-database = {
    #   url = "github:nix-community/nix-index-database";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
}
