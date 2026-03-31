{
  a2ps,
  coreutils,
  dpkg,
  fetchurl,
  file,
  gawk,
  ghostscript_headless,
  gnused,
  makeWrapper,
  lib,
  stdenvNoCC,
  pkgsi686Linux,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mfc9332cdwlpr";
  version = "1.1.3-0";

  dlfid = "dlf101620";

  src = fetchurl {
    url = "http://download.brother.com/welcome/${finalAttrs.dlfid}/${finalAttrs.pname}-${finalAttrs.version}.i386.deb";
    hash = "sha256-irE272qZ96u27jH3UhjCm6AqRanbwq4wFL0Rvi5nuFY=";
  };

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
    patchelf "$out/opt/brother/Printers/mfc9332cdw/lpd/brmfc9332cdwfilter" \
      --set-interpreter "${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2"

    wrapProgram "$out/opt/brother/Printers/mfc9332cdw/lpd/brmfc9332cdwfilter" \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    patchelf "$out/usr/bin/brprintconf_mfc9332cdw" \
      --set-interpreter "${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2"

    wrapProgram "$out/usr/bin/brprintconf_mfc9332cdw" \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    substituteInPlace "$out/opt/brother/Printers/mfc9332cdw/inf/setupPrintcapij" \
      --replace-fail '/opt/' "$out/opt/"

    wrapProgram "$out/opt/brother/Printers/mfc9332cdw/inf/setupPrintcapij" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }

    substituteInPlace "$out/opt/brother/Printers/mfc9332cdw/lpd/filtermfc9332cdw" \
      --replace-fail '/opt/' "$out/opt/"

    wrapProgram "$out/opt/brother/Printers/mfc9332cdw/lpd/filtermfc9332cdw" \
      --prefix PATH : ${
        lib.makeBinPath [
          a2ps
          coreutils
          file
          ghostscript_headless
          gnused
        ]
      }

    substituteInPlace "$out/opt/brother/Printers/mfc9332cdw/lpd/psconvertij2" \
      --replace-fail '`which gs`' "${ghostscript_headless}/bin/gs"

    wrapProgram "$out/opt/brother/Printers/mfc9332cdw/lpd/psconvertij2" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnused
        ]
      }

    mkdir $out/bin
    ln -s "$out/usr/bin/brprintconf_mfc9332cdw" "$out/bin/"
  '';

  meta = {
    description = "Brother MFC-9332CDW LPR printer driver";
    homepage = "http://www.brother.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      unfree
    ];
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
