{ lib
, stdenv
, fetchFromGitHub
, cmake
, fftw
, fftwFloat
, pkg-config
, avxSupport ? stdenv.hostPlatform.avxSupport
, fmaSupport ? stdenv.hostPlatform.fmaSupport
}:

stdenv.mkDerivation {
  pname = "tfhe";
  version = "git-2020-04-14";

  src = fetchFromGitHub {
    owner = "tfhe";
    repo = "tfhe";
    rev = "a085efe91314f994285fcb06ab8bdae3d55e4505";
    sha256 = "1vjf8ql75mm0b1yn8dgf6xvv01kcfyg2zh932xhr0yzylc5s5j4x";
  };

  setSourceRoot = "sourceRoot=`pwd`/source/src";

  buildInputs = [ cmake pkg-config ];
  nativeBuildInputs = [ fftw fftwFloat ];

  cmakeFlags =
    let
      toOnOff = b: if b then "on" else "off";
    in
    [
      "-DENABLE_FFTW=on"
      "-DENABLE_NAYUKI_PORTABLE=on"
      "-DENABLE_NAYUKI_AVX=${toOnOff avxSupport}"
      "-DENABLE_SPQLIOS_AVX=${toOnOff avxSupport}"
      "-DENABLE_SPQLIOS_FMA=${toOnOff fmaSupport}"
    ];

  meta = with lib; {
    description = "A library for fully homomorphic encryption";
    homepage = "https://tfhe.github.io/tfhe/";
    license = licenses.asl20;
  };
}
