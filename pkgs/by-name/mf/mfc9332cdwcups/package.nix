{
  coreutils,
  cups,
  dpkg,
  fetchurl,
  gnused,
  makeWrapper,
  mfc9332cdwlpr,
  lib,
  stdenvNoCC,
  pkgsi686Linux,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mfc9332cdwcupswrapper";
  version = "1.1.4-0";

  dlfid = "dlf101621";

  src = fetchurl {
    url = "http://download.brother.com/welcome/${finalAttrs.dlfid}/${finalAttrs.pname}-${finalAttrs.version}.i386.deb";
    hash = "sha256-vGSEWzZ+ga2RQe8DjGgJbkv7wzp2i4n5B4i+3CBIPuE=";
  };

  buildInputs = [
    cups
    mfc9332cdwlpr
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src $out
    runHook postUnpack
  '';

  preFixup = ''
    patchelf "$out/opt/brother/Printers/mfc9332cdw/cupswrapper/brcupsconfpt1" \
      --set-interpreter "${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2"

    wrapProgram "$out/opt/brother/Printers/mfc9332cdw/cupswrapper/cupswrappermfc9332cdw" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }
  '';

  meta = {
    description = "Brother MFC-9332CDW LPR printer driver cups wrapper";
    homepage = "http://www.brother.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
    ];
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
