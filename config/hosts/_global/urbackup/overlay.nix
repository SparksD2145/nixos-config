{
  config,
  pkgs,
  lib,
  ...
}:
{
  # [...]
  nixpkgs.overlays = [
    (final: prev: {

      urbackup-client =
        with final;
        stdenv.mkDerivation rec {
          pname = "urbackup-client";
          version = "2.5.29";

          src = fetchzip {
            url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
            sha256 = "sha256-c545e91e731473d9cc5165ea33f8ed69c4e1d939f0342ebfe089d5fb63078a49";
          };

          enableParallelBuilding = true;

          patches = [
            ./client-fix-install.patch
          ];

          # Needed for building from the Git source (versioned source downloads are pre-configured to server or client)
          # postPatch = ''
          #   patchShebangs --build switch_build.sh
          #   ./switch_build.sh client
          # '';

          configureFlags = [
            "--with-crypto-prefix=${cryptopp.dev}"
            "--localstatedir=/var/lib/urbackup-client"
          ];

          nativeBuildInputs = [
            autoreconfHook
            pkg-config
          ];

          buildInputs = [
            wxGTK32
            zlib
            zstd
            curl
            cryptopp
          ];
        };
    })
  ];
}
