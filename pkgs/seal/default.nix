{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, zlib
}:

stdenv.mkDerivation rec {
  pname = "seal";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "SEAL";
    rev = "v${version}";
    sha256 = "1klc0fga2mhvfqxsyhysxa8y1asmad58jdhp94lmqzhh87i42svq";
  };

  nativeBuildInputs = [ cmake gtest ];
  propagatedBuildInputs = [ zlib ];

  patches = [
    ./0000-install-to-expected-includes-and-config-directories.patch
  ];

  cmakeFlags = [
    "-DSEAL_BUILD_DEPS=OFF"
    "-DSEAL_USE_MSGSL=OFF"
    "-DSEAL_USE_ZSTD=OFF"
    "-DSEAL_BUILD_TESTS=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  checkPhase = ''
    export LD_LIBRARY_PATH=./lib
    ./bin/sealtest \
      --gtest_filter=-SerializationTest.IsValidHeader # incorrectly invalidates a zstd header
  '';

  meta = with lib; {
    description = "An easy-to-use and powerful homomorphic encryption library";
    homepage = "https://sealcrypto.org";
    lisense = licenses.mit;
  };
}
