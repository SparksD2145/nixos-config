### Collected from: https://github.com/NixOS/nixpkgs/issues/277101

{
  description = "An over-engineered Hello World in C";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }
      );

    in
    {

      # A Nixpkgs overlay.
      # overlay = final: prev: {

      #   urbackup-client =
      #     with final;
      #     stdenv.mkDerivation rec {
      #       pname = "urbackup-client";
      #       version = "2.5.29";

      #       src = fetchFromGitHub {
      #         owner = "uroni";
      #         repo = "urbackup_backend";
      #         rev = "refs/tags/${version}client";
      #         hash = "sha256-6oxSaLDg0ca8vFwgprB0w52cg/EHZ1H94f0AHKTMt2w=";
      #       };

      #       # src = fetchzip {
      #       #   url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
      #       #   sha256 = "sha256-i1g3xUhspqQRfIUhy6STOWNuncK3tMFocJw652r1X9g=";
      #       # };

      #       enableParallelBuilding = true;

      #       # patches = [
      #       #   ./client-fix-install.patch
      #       # ];

      #       # Needed for building from the Git source (versioned source downloads are pre-configured to server or client)
      #       postPatch = ''
      #         patchShebangs --build switch_build.sh
      #         ./switch_build.sh client
      #       '';

      #       configureFlags = [
      #         "--with-crypto-prefix=${cryptopp.dev}"
      #         "--localstatedir=/var/lib/urbackup-client"
      #         "--enable-headless"
      #       ];

      #       nativeBuildInputs = [
      #         autoreconfHook
      #         pkg-config
      #       ];

      #       buildInputs = [
      #         zlib
      #         zstd
      #         # curl
      #         cryptopp
      #         curlWithGnuTls
      #         autoconf
      #         automake
      #         libtool
      #       ];
      #     };
      # };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) urbackup-client;
      });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      # defaultPackage = forAllSystems (system: self.packages.${system}.urbackup-server);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules = {
        urbackup-client =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          with lib;
          let
            cfg = config.services.urbackup-client;
            settingsFormat = pkgs.formats.keyValue { };
          in
          {
            imports = [ ];
            options.services.urbackup-client = {
              enable = mkEnableOption (mkDoc "UrBackup client daemon");

              user = mkOption {
                type = types.str;
                default = "root"; # "urbackup-client";
                description = mdDoc ''
                  User account under which the UrBackup client runs.
                '';
              };

              group = mkOption {
                type = types.str;
                default = "root"; # "urbackup-client";
                description = mdDoc ''
                  Group under which the UrBackup client runs.
                '';
              };

              otherSettings = mkOption {
                type = settingsFormat.type;
                default = { };
                description = ''
                  Configuration for the UrBackup client. See https://github.com/uroni/urbackup_backend/blob/2.5.x/defaults_client
                '';
              };
            };

            config = {
              # nixpkgs.overlays = [ self.overlay ];

              environment.systemPackages = [ pkgs.urbackup-client ];

              users.users = mkIf (cfg.user == "urbackup-client") {
                urbackup-client = {
                  group = cfg.group;
                  description = "UrBackup client daemon user";
                  isSystemUser = true;
                };
              };

              users.groups = mkIf (cfg.group == "urbackup-client") {
                urbackup-client = { };
              };

              # See https://github.com/uroni/urbackup_backend/blob/2.5.x/defaults_client
              services.urbackup-client.otherSettings = {
                # Defaults for urbackup_client initscript

                #logfile name
                LOGFILE = mkDefault "/var/log/urbackup-client/urbackupclient.log";

                #Either debug,warn,info or error
                LOGLEVEL = mkDefault "debug";

                #Max size of the log file before rotation
                #Disable if you are using logrotate for
                #more advanced configurations (e.g. with compression)
                LOG_ROTATE_FILESIZE = mkDefault 20971520;

                #Max number of log files during rotation
                LOG_ROTATE_NUM = mkDefault 10;

                #Tmp file directory
                DAEMON_TMPDIR = mkDefault "/tmp";

                # Valid settings:
                #
                # "client-confirms": If you have the GUI component the currently active user
                #                    will need to confirm restores from the web interface.
                #                    If you have no GUI component this will cause restores
                #                    from the server web interface to not work
                # "server-confirms": The server will ask the user starting the restore on
                #                    the web interface for confirmation
                # "disabled":        Restores via web interface are disabled.
                #                    Restores via urbackupclientctl still work
                #
                RESTORE = mkDefault "disabled";

                #If true client will not bind to any external network ports (either true or false)
                INTERNET_ONLY = mkDefault true;
              };

              networking.firewall = mkIf cfg.enable {
                allowedTCPPorts = [
                  # "Sending files during file backups (file server)"
                  35621
                  # "Commands and image backups"
                  35623
                ];
                allowedUDPPorts = [
                  # "UDP broadcasts for discovery"
                  35622
                ];
              };

              systemd.services.urbackup-client = mkIf cfg.enable {
                description = "UrBackup Client backend";
                after = [
                  "syslog.target"
                  "network.target"
                ];
                wantedBy = [ "multi-user.target" ];
                path = [
                  pkgs.urbackup-client
                  config.boot.zfs.package
                ];
                serviceConfig = {
                  User = cfg.user;
                  Group = cfg.group;
                  ExecStart = "${pkgs.urbackup-client}/bin/urbackupclientbackend --config ${settingsFormat.generate "urbackupclient" cfg.otherSettings} --no-consoletime --loglevel debug";
                  StateDirectory = "urbackup-client/urbackup urbackup-client/urbackup/data";
                  WorkingDirectory = "/var/lib/urbackup-client"; # Overridden by a hardcoded path in the binary(?)
                  LogsDirectory = "urbackup-client";
                  #TasksMax = "infinity";
                  # CAP_SETUID needed to switch to root user to control ZFS datasets
                  # CAP_SYS_NICE needed to
                  #AmbientCapabilities = "CAP_SETUID CAP_SYS_NICE";
                };
              };
            };
          };
      };
    };
}
