{ stdenv, lib, fetchurl, fetchgit
, git, flex, bison, zlib, curl, ...
}:

let
  VERSION_GMP	= "6.2.0";
  VERSION_MPFR	= "4.1.0";
  VERSION_MPC	= "1.2.0";
  VERSION_BINUTILS = "2.35";
  VERSION_GCC	= "8.3.0";
  VERSION_NASM	= "2.15.03";
  VERSION_ACPICA = "20200717";

  FNAME_GMP	= "gmp-${VERSION_GMP}.tar.xz";
  FNAME_MPFR	= "mpfr-${VERSION_MPFR}.tar.xz";
  FNAME_MPC	= "mpc-${VERSION_MPC}.tar.gz";
  FNAME_BINUTILS = "binutils-${VERSION_BINUTILS}.tar.xz";
  FNAME_GCC	= "gcc-${VERSION_GCC}.tar.xz";
  FNAME_NASM	= "nasm-${VERSION_NASM}.tar.bz2";
  FNAME_ACPICA  = "acpica-unix2-${VERSION_ACPICA}.tar.gz";

  src_gmp = fetchurl {
    url = "https://ftpmirror.gnu.org/gmp/${FNAME_GMP}";
    sha256 = "09hmg8k63mbfrx1x3yy6y1yzbbq85kw5avbibhcgrg9z3ganr3i5";
  };

  src_mpfr = fetchurl {
    url = "https://ftpmirror.gnu.org/mpfr/${FNAME_MPFR}";
    sha256 = "0zwaanakrqjf84lfr5hfsdr7hncwv9wj0mchlr7cmxigfgqs760c";
  };

  src_mpc = fetchurl {
    url = "https://ftpmirror.gnu.org/mpc/${FNAME_MPC}";
    sha256 = "19pxx3gwhwl588v496g3aylhcw91z1dk1d5x3a8ik71sancjs3z9";
  };

  src_binutils = fetchurl {
    url = "https://ftpmirror.gnu.org/binutils/${FNAME_BINUTILS}";
    sha256 = "119g6340ksv1jkg6bwaxdp2whhlly22l9m30nj6y284ynjgna48v";
  };

  src_gcc = fetchurl {
    url = "https://ftpmirror.gnu.org/gcc/gcc-${VERSION_GCC}/${FNAME_GCC}";
    sha256 = "0b3xv411xhlnjmin2979nxcbnidgvzqdf4nbhix99x60dkzavfk4";
  };

  src_nasm = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${VERSION_NASM}/${FNAME_NASM}";
    sha256 = "0y6p3d5lhmwzvgi85f00sz6c485ir33zd1nskzxby4pikcyk9rq4";
  };

  src_acpica = fetchurl {
    url = "https://acpica.org/sites/acpica/files/${FNAME_ACPICA}";
    sha256 = "0jyy71szjr40c8v40qqw6yh3gfk8d6sl3nay69zrn5d88i3r0jca";
  };
in
stdenv.mkDerivation rec {
  pname = "coreboot-toolchain";
  version = "4.13";

  nativeBuildInputs = [ git flex curl bison zlib ];

  src = fetchgit {
    url = "https://review.coreboot.org/coreboot";
    rev = "refs/tags/${version}";
    sha256 = "17ykaq1wk5phbdirnr0dbzg6p6p38ch5i6r3rxd01rg8sin58rlp";
    leaveDotGit = true;
  };

  patchPhase = ''
    mkdir util/crossgcc/tarballs
    cp ${src_gmp}	util/crossgcc/tarballs/${FNAME_GMP}
    cp ${src_mpfr}	util/crossgcc/tarballs/${FNAME_MPFR}
    cp ${src_mpc}	util/crossgcc/tarballs/${FNAME_MPC}
    cp ${src_binutils}	util/crossgcc/tarballs/${FNAME_BINUTILS}
    cp ${src_gcc}	util/crossgcc/tarballs/${FNAME_GCC}
    cp ${src_nasm}	util/crossgcc/tarballs/${FNAME_NASM}
    cp ${src_acpica}	util/crossgcc/tarballs/${FNAME_ACPICA}
  '';

  buildPhase = ''
    make crossgcc-i386
  '';

  installPhase = ''
    mkdir -p $out
    ls -lah $out
    cp -r util/crossgcc/xgcc/* $out/
    ls -lah $out
  '';

  meta = with lib; {
    description = "coreboot toolchain";
    homepage = "https://www.coreboot.org";
    license = licenses.mit;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
