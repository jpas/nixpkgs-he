{ lib
, stdenv
, fetchFromGitHub
, ntl
}:

stdenv.mkDerivation {
  pname = "heaan";
  version = "git-2020-12-08";

  src = fetchFromGitHub {
    owner = "snucrypto";
    repo = "HEAAN";
    rev = "131d275b2ed071a263fce4d367d418bb23b9bf53";
    sha256 = "13adrcmfm0clr16girkqwqrscdv3bshpbqi0zv9wa0rwrrqmhpaq";
  };

  setSourceRoot = "sourceRoot=`pwd`/source/HEAAN/lib";

  buildInputs = [ ntl ];

  installPhase = ''
    install -dm755 $out/lib
    install -m644 libHEAAN.a $out/lib/
    install -dm755 $out/include
    install -m644 ../src/*.h $out/include/
  '';

  meta = with lib; {
    description = "A library implementing the original HEAAN (aka. CKKS) scheme";
    inherit (src) homepage;
    license = licenses.cc-by-nc-30;
  };
}
