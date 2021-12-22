{ fetchgit
, gcc10
, hostname
, lib
, libusb1
, openssl
, pkg-config
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "gsctool";
  version = "unstable-2022-03-13";

  nativeBuildInputs = [ hostname pkg-config ];
  buildInputs = [ gcc10 libusb1 openssl ];

  postPatch = ''
    patchShebangs util/getversion.sh
  '';

  preBuild = ''
    cd extra/usb_updater
  '';

  installPhase = ''
    install -Dm755 gsctool -t $out/bin
  '';

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/ec";
    rev = "8f0ac179f8550ab4939f2a23d0a6ac62b98ca243";
    sha256 = "150x3y0j3hciz8qfd91id9q7n4i2mg2sjapysr6ayixc9m9naz4w";
  };

  meta = with lib; {
    description = "A tool to update CR50 firmware";
    homepage = "https://chromium.googlesource.com/chromiumos/platform/ec";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
