{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  darwin,
  makeWrapper,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices;
  pname = "cargo-mobile2";
  version = "0.17.6";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "cargo-mobile2-v${version}";
    hash = "sha256-kIy5Ic7Zk6twcEbZN/wRLwMK0XeMF0lNkFDIc2vO944=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "${src.name}/tooling/cli";

  useFetchCargoVendor = true;
  cargoHash = "sha256-An9EuNv+6ttNKp50RutzxtHl/RS5gn9sUNlWtipAujk=";

  preBuild = ''
    mkdir -p $out/share/
    # during the install process tauri-mobile puts templates and commit information in CARGO_HOME
    export CARGO_HOME=$out/share/
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];
  nativeBuildInputs = [
    pkg-config
    git
    makeWrapper
  ];

  preFixup = ''
    for bin in $out/bin/cargo-*; do
      wrapProgram $bin \
        --set CARGO_HOME "$out/share"
    done
  '';

  meta = with lib; {
    description = "Rust on mobile made easy!";
    homepage = "https://tauri.app/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ happysalada ];
  };
}
