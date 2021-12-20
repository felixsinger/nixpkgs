{ fetchgit
, flashrom
, lib
, libuuid
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "vpdtool";
  version = "unstable-2017-12-11";
  
  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/vpd";
    rev = "ea4ece04cb84d426c1ddf1b6a06dd5ba22115871";
    sha256 = "0ag356nyskbjqmx47s53gp26nq4flllbifzkcrdza7l3y5g9790m";
  };

  buildInputs = [ libuuid ];
  propagatedBuildInputs = [ flashrom ];

  makeFlags = [ "vpd" ];

  installPhase = ''
    install -Dm755 vpd -t $out/bin
  '';

  meta = with lib; {
    description = "Tool for modifying VPD key/value storage";
    homepage = "https://chromium.googlesource.com/chromiumos/platform/vpd";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
