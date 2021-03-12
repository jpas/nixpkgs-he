{ pkgs ? import <nixpkgs> { } }:

let
  packages = self:
    let
      callPackage = pkgs.newScope self;
    in
    {
      inherit
        callPackage
        ;

      # NOTE(jpas): We don't need a derivation for concrete since rust typically
      # uses cargo to ensure reproducibility. Thus we only need this if we want to
      # use any of their binaries. It mostly serves as a place to document what
      # is needed to build it.
      concrete = callPackage ./pkgs/concrete { };

      hare = callPackage ./pkgs/hare { };

      heaan = callPackage ./pkgs/heaan { };

      helib = callPackage ./pkgs/helib { };

      # TODO(jpas): https://github.com/idsec/lattigo
      # NOTE(jpas), We don't need a derivation for lattigo since go typically uses
      # go.mod to ensure reproducibility. Thus we only need this if we want to use
      # any of their binaries.
      #lattigo = callPackage ./pkgs/lattigo { };

      # TODO(jpas): https://github.com/cpeikert/Lol
      # NOTE(jpas): Lol currently uses stack with an older version ghc, but I have
      # been working on porting it to current Haskell, so far so good.
      #lol = callPackage ./pkgs/lol { };

      palisade = callPackage ./pkgs/palisade { };

      seal = callPackage ./pkgs/seal { };

      tfhe = callPackage ./pkgs/tfhe { };

      tfhepp = callPackage ./pkgs/tfhepp { };

      # GPU targeting libraries:
      # https://github.com/vernamlab/cuFHE -> implements TFHE in CUDA
      # https://github.com/nucypher/nufhe -> implements TFHE in CUDA + OpenCL

      # SEE ALSO:
      # https://bitbucket.org/malb/lwe-estimator/
      # https://github.com/MarbleHE/SoK/wiki
      # https://github.com/jonaschn/awesome-he

      # "Compilers"
      # https://github.com/MarbleHE/Marble -> targets HELib from 2 years ago
      # https://github.com/virtualsecureplatform/Iyokan -> targets TFHEpp
      # https://github.com/ibarrond/Pyfhel -> targets SEAL and PALISADE
      # https://github.com/cpeikert/ALCHEMY -> targets Lol
      # https://github.com/CEA-LIST/Cingulata -> targets TFHE
      # https://github.com/IntelAI/he-transformer -> targets SEAL CKKS
      # https://github.com/alan-turing-institute/SHEEP -> targets TFHE, HElib, SEAL
      # https://github.com/microsoft/EVA/ -> targets SEAL CKKS
      # RAMPARTS: https://dl.acm.org/doi/10.1145/3338469.3358945, closed source
      # SEALion: https://arxiv.org/pdf/1904.12840.pdf, closed source

      # Other related libraries:
      # https://github.com/quarkslab/NFLlib, only fast lattice operations
    };

in
pkgs.lib.fix' packages
