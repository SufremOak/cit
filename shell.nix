{ lib, stdenv, rustPlatform, clang, wasmer, fetchFromGitHub, cmake, make }:

stdenv.mkDerivation rec {
  pname = "cit";
  version = "v0.1.0";

  # We assume a Cargo.toml file is present to define dependencies for the Rust project
  src = ./.;

  nativeBuildInputs = [ cmake make ];

  buildInputs = [
    rustPlatform.rust
    clang
    wasmer
  ];

  # Define environment variables and set up paths for tools
  shellHook = ''
    export CARGO_TARGET_DIR=${toString ./target}
    export PATH=${rustPlatform.rustPackages.stable.rustc}/bin:$PATH
    export WASMER=${wasmer}/bin/wasmer
    export CC=${clang}/bin/clang
  '';

  meta = with lib; {
    description = "Cit: A project involving Rust, Clang, and Wasmer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
