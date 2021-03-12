{ lib
, stdenv
, fetchFromGitLab
, cmake
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "hare";
  version = "git-2019-04-29";

  src = fetchFromGitLab {
    owner = "fvhpr";
    repo = "hare";
    rev = "a44da66d9e7806f985ad0d3ac42a19965cfef16f";
    sha256 = "0cla535j77jkvfrzf56vigh6df36mz040n83l9awvqynzgfyldzw";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp mpfr ];

  postInstall = ''
    mkdir -p $out/bin/
    install -m755 -T main2 $out/bin/hare
  '';

  meta = with lib; {
    description = "An HPR variant of the FV scheme";
    inherit (src) homepage;
    license = licenses.gpl3;
  };
}
