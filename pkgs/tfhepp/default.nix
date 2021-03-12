{ lib
, stdenv
, fetchFromGitHub
, cereal
, cmake
}:

stdenv.mkDerivation {
  pname = "tfhepp";
  version = "2021-03-12";

  src = fetchFromGitHub {
    owner = "virtualsecureplatform";
    repo = "TFHEpp";
    rev = "efd19351a43f479b5b714ade73ac1dfc9e3d3e7d";
    sha256 = "0rxjlsxs0n6xnyg2jlm60a2hrslrd8wg29dhpxcc2zwd3icj8vjv";
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
