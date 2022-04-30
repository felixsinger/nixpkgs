{ fetchFromGitHub
, lib
, libusb1
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "xfel";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = pname;
    rev = "v${version}";
    sha256 = "05n615wark5hswqvbj6hzm5ab0n36w3bv57pxw9a1ddic0s1h567";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installPhase = ''
    runHook preInstall

    install -Dm755 xfel $out/bin/xfel
    install -Dm644 99-xfel.rules $out/lib/udev/rules.d/xfel.rules

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tiny FEL tools for allwinner SOCs";
    homepage = "https://github.com/xboot/xfel";
    license = licenses.mit;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
