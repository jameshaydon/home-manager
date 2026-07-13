{
  description = "Home Manager configuration of james";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    emacs-lsp-booster.inputs.nixpkgs.follows = "nixpkgs";
    gws = {
      url = "github:googleworkspace/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-agent-acp = {
      url = "github:agentclientprotocol/claude-agent-acp/v0.58.1";
      flake = false;
    };
    codex-acp = {
      url = "github:agentclientprotocol/codex-acp/v1.1.2";
      flake = false;
    };
    pi-acp = {
      url = "github:svkozak/pi-acp/v0.0.31";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, emacs-lsp-booster, gws, claude-agent-acp, codex-acp, pi-acp, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      my-overlays = {
          nixpkgs.overlays = [
            emacs-lsp-booster.overlays.default
          ];
        };
    in {
      homeConfigurations."james" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          my-overlays
          { home.packages = [ gws.packages.${system}.gws ]; }
        ];

        extraSpecialArgs.agentSources = {
          claude = claude-agent-acp;
          codex = codex-acp;
          pi = pi-acp;
        };
      };
    };
}
