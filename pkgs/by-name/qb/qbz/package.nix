{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  fetchNpmDeps,

  cargo-tauri,

  nodejs,
  npmHooks,
  pkg-config,

  alsa-lib,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "1.1.14";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s7eMc800na7xlQ4cB25rcM30EoE8F8VCZcZ8NxMsnCA=";
  };

  cargoHash = "sha256-Q2KhNPrUU8X95Z7qsWqwkFDzJlLAmpH1Fn5f47fABCD=";

  cargoRoot = "src-tauri";

  npmDeps = fetchNpmDeps {
    name = "qbz-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-iaxNrZLcb9qM5EPRtzoXw6izZBeS/rqgGaZpA2A2AAA=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
#    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    webkitgtk_4_1
  ];

  # To fix `npm ERR! Your cache folder contains root-owned files`
#  makeCacheWritable = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
    homepage = "https://qbz.lol";
    changelog = "https://github.com/vicrodh/qbz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    mainProgram = "qbz";
    platforms = lib.platforms.linux;
  };
})
