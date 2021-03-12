{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, fftw
, fftwFloat
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "concrete";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "zama-ai";
    repo = "concrete";
    # There are no tags for versions on this repo...
    rev = "fff309ec8df99ed5a02e754fbc382da89691c918";
    sha256 = "1jqx0v6lf5fjxzfg974ba6lj42lg9x1582cskjphxx5jw6nf9xyz";
  };

  cargoPatches = [ ./add-Cargo.lock.patch ];

  cargoSha256 = "07d46n965mzj9dkffsnqc43f1y3pdwln997lspziz2yikq5zqkfs";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fftw fftwFloat openssl pkg-config ];

  # Needed to get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description =
      "A fully homomorphic encryption library implementing Zama's variant of TFHE";
    inherit (src) homepage;
    license = licenses.agpl3;
  };
}
