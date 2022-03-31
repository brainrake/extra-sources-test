{
  description = "A very basic flake";
  inputs.haskell-nix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mydep = {
    url = "./mydep";
    flake = false;
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, haskell-nix, mydep, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        overlays = [
          haskell-nix.overlay
          (final: prev: {
            mypackage-project =
              final.haskell-nix.cabalProject' {
                src = ./.;
                compiler-nix-name = "ghc8107";
                index-state = "2022-02-22T00:00:00Z";
                pkg-def-extras = [ (hackage: { mydep = import "${inputs.mydep.src}/mydep.nix"; }) ];
                shell = {
                  tools = {
                    cabal = { };
                    hlint = { };
                    haskell-language-server = { };
                  };
                  buildInputs = with pkgs; [ nixpkgs-fmt ];
                };
              };
          })
        ];
        pkgs = import
          nixpkgs
          { inherit system overlays; inherit (haskell-nix) config; };
        flake = pkgs.mypackage-project.flake
          { };
      in
      flake // {
        # Built by `nix build .`
        defaultPackage = flake.packages."mypackage:exe:myexe";
      });
}
