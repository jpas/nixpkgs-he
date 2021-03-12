{ lib
, stdenv
, fetchFromGitHub
, cmake
, gmp
, ntl
}:

stdenv.mkDerivation rec {
  pname = "helib";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "homenc";
    repo = "HElib";
    rev = "v${version}";
    sha256 = "159fci0wf0l6x3n4i23v295bl0m9ywar5grxcp3kas8vc429d5hc";
  };

  cmakeFlags = [
    "-DBUILD_SHARED=ON"
    "-DGMP_DIR=${gmp}/lib"
    "-DGMP_HEADERS=${gmp}/include"
    "-DNTL_DIR=${ntl}"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ntl ];

  meta = with lib; {
    description = "A homomorphic encryption library";
    homepage = "homenc.github.io/helib";
    license = licenses.asl20;
  };
}
