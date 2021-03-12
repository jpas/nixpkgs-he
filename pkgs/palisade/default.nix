{ lib
, stdenv
, fetchFromGitLab
, autoconf
, cereal
, cmake
}:

stdenv.mkDerivation rec {
  pname = "palisade";
  version = "1.10.6";

  src = fetchFromGitLab {
    owner = "palisade";
    repo = "palisade-release";
    rev = "v${version}";
    sha256 = "11q23pfl34fqxysb8f35acdnmrdfgzzgrjxmjxpg4azk6p5qslyk";
  };

  patches = [
    ./0001-remove-unused-required-git.patch
    ./0002-remove-unused-required-autoconf.patch
    ./0003-change-thirdparty-cereal-to-package.patch
  ];

  nativeBuildInputs = [ cmake cereal ];

  cmakeFlags =
    let
      toOnOff = b: if b then "ON" else "OFF";
    in
    [
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_BENCHMARKS=OFF" # TODO(jpas): build these?
      "-DBUILD_UNITTESTS=${toOnOff doCheck}"
    ];

  # TODO(jpas): fix test suite to compile with nixpkgs gtest
  doCheck = false;

  meta = with lib; {
    description = "A general lattice based cryptography library";
    homepage = "https://palisade-crypto.org";
    license = licenses.bsd2;
  };
}
