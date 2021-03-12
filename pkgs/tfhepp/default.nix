{ lib
, stdenv
, fetchFromGitHub
, cereal
, cmake
}:

stdenv.mkDerivation {
  pname = "tfhepp";
  version = "git-2021-02-22";

  src = fetchFromGitHub {
    owner = "virtualsecureplatform";
    repo = "TFHEpp";
    rev = "ac85933131c3ff9302947ba75c138226f4de667a";
    sha256 = "05q635c33fl1b0qcnx3svwlc1d9mr06drs0frhyzipvl1zg132nd";
  };

  patches = [
    ./0001-remove-optimization-flags.patch
    ./0002-add-find-package-cereal.patch
  ];

  NIX_CFLAGS_COMPILE = [ "-maes" "-mavx" "-mfma" ];

  nativeBuildInputs = [ cmake cereal ];

  postInstall = ''
    install -dm755 $out/include $out/include/params
    install -m644 ../include/*.hpp $out/include/
    install -m644 ../include/params/*.hpp $out/include/params/
  '';

  meta = with lib; {
    description = "A pure C++ implementation of TFHE";
    inherit (src) homepage;
    license = licenses.asl20;
  };
}
