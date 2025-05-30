{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  scdoc,
  ffmpeg,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "twitch-dl";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "twitch-dl";
    tag = version;
    hash = "sha256-L+IbcSUaxhTg2slNc5x1VJPnA5e2qrPEeWjspK2COAI=";
  };

  pythonRelaxDeps = [
    "m3u8"
  ];

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
    installShellFiles
    scdoc
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    httpx
    m3u8
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_api.py"
    "tests/test_cli.py"
  ];

  pythonImportsCheck = [
    "twitchdl"
    "twitchdl.cli"
    "twitchdl.naming"
    "twitchdl.entities"
    "twitchdl.http"
    "twitchdl.output"
    "twitchdl.playlists"
    "twitchdl.progress"
    "twitchdl.twitch"
    "twitchdl.utils"
    "twitchdl.commands"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  postInstall = ''
    scdoc < twitch-dl.1.scd > twitch-dl.1
    installManPage twitch-dl.1
  '';

  meta = with lib; {
    description = "CLI tool for downloading videos from Twitch";
    homepage = "https://github.com/ihabunek/twitch-dl";
    changelog = "https://github.com/ihabunek/twitch-dl/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      pbsds
      hausken
    ];
    mainProgram = "twitch-dl";
  };
}
