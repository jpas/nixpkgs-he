{
  description = "A collection of packages related to homomorphic encryption";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat }:
    let
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = self.overlays;
      };
    in
    {
      overlay = final: prev:
        let
          he = {
            #heaan = final.callPackage ./pkgs/heaan { };
            helib = final.callPackage ./pkgs/helib { };
            palisade = final.callPackage ./pkgs/palisade { };
            seal = final.callPackage ./pkgs/seal { };
            tfhe = final.callPackage ./pkgs/tfhe { };
            tfhepp = final.callPackage ./pkgs/tfhepp { };
          };
        in
        he // { inherit he; };

      overlays = [ self.overlay ];

      packages = forAllSystems (system: (pkgsFor system).he);

      defaultPackage = forAllSystems (system:
        let pkgs = pkgsFor system; in
        pkgs.linkFarmFromDrvs "he-packages-unstable"
          (builtins.attrValues pkgs.he)
      );
    };
}
