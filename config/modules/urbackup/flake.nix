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
      overlay = final: prev: {

        urbackup-client =
          with final;
          stdenv.mkDerivation rec {
            pname = "urbackup-client";
            version = "2.5.25";

            src = fetchzip {
              url = "https://hndl.urbackup.org/Client/${version}/urbackup-client-${version}.tar.gz";
              sha256 = "sha256-i1g3xUhspqQRfIUhy6STOWNuncK3tMFocJw652r1X9g=";
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

        urbackup-server =
          with final;
          stdenv.mkDerivation rec {
            pname = "urbackup-server";
            version = "2.5.32";

            src = fetchzip {
              url = "https://hndl.urbackup.org/Server/${version}/urbackup-server-${version}.tar.gz";
              sha256 = "sha256-LEn77/sB3Y7U/opQUandDAamFkrMDcVwVUBrCKUI3ys=";
            };

            #src = fetchgit {
            #  url = "https://github.com/uroni/urbackup_backend";
            #  rev = "bbfe4b44aa6ca0fb6729347f2fce6018a4be8898";
            #  sha256 = "sha256-XOHid1TflJ3Kg2IRjIzsHT6/yGCXP2UzbQ6IQPXBMg0=x";
            #};

            enableParallelBuilding = true;

            patches = [
              ./server-fix-install.patch
            ];

            # Needed for building from the Git source (versioned source downloads are pre-configured to server or client)
            # postPatch = ''
            #   patchShebangs --build switch_build.sh
            #   ./switch_build.sh server
            # '';

            configureFlags = [
              # "--with-mountvhd"
              "--enable-packaging"
              "--with-crypto-prefix=${cryptopp.dev}"
              "--localstatedir=/var/lib/urbackup-server"
            ];

            nativeBuildInputs = [
              autoreconfHook
              pkg-config
            ];

            buildInputs = [
              zlib
              zstd
              curl
              cryptopp
              # fuse
            ];
          };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) urbackup-server urbackup-client;
      });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      # defaultPackage = forAllSystems (system: self.packages.${system}.urbackup-server);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules = {
        urbackup-server =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          with lib;
          let
            cfg = config.services.urbackup-server;
            settingsFormat = pkgs.formats.keyValue { };
          in
          {
            imports = [ ];
            options.services.urbackup-server = {
              enable = mkEnableOption (mkDoc "UrBackup server daemon");

              user = mkOption {
                type = types.str;
                default = "root"; # "urbackup-server";
                description = mdDoc ''
                  User account under which the UrBackup server runs.
                '';
              };

              group = mkOption {
                type = types.str;
                default = "root"; # "urbackup-server";
                description = mdDoc ''
                  Group under which the UrBackup server runs.
                '';
              };

              otherSettings = mkOption {
                type = settingsFormat.type;
                default = { };
                description = ''
                  Configuration for the UrBackup server. See https://github.com/uroni/urbackup_backend/blob/2.5.x/defaults_server
                '';
              };

              portForward = mkOption {
                type = lib.types.bool;
                default = true;
                description = lib.mdDoc ''
                  Whether allow UrBackup ports through the firewall.
                '';
              };

              cgiPort = mkOption {
                type = types.port;
                default = 55413;
                description = mdDoc ''
                  Port to use for the UrBackup server FastCGI web interface.
                '';
              };

              httpPort = mkOption {
                type = types.port;
                default = 55414;
                description = mdDoc ''
                  Port to use for the UrBackup server HTTP web interface.
                '';
              };

              internetPort = mkOption {
                type = types.port;
                default = 55415;
                description = mdDoc ''
                  Port to use for the UrBackup server internet client.
                '';
              };
            };
            config = {
              nixpkgs.overlays = [ self.overlay ];

              environment.systemPackages = [ pkgs.urbackup-server ];

              users.users = mkIf (cfg.user == "urbackup-server") {
                urbackup-server = {
                  group = cfg.group;
                  description = "UrBackup server daemon user";
                  isSystemUser = true;
                };
              };

              users.groups = mkIf (cfg.group == "urbackup-server") {
                urbackup-server = { };
              };

              # See https://github.com/uroni/urbackup_backend/blob/2.5.x/defaults_server
              services.urbackup-server.otherSettings = {
                # Defaults for urbackupsrv initscript

                #Port for FastCGI requests
                FASTCGI_PORT = mkDefault cfg.cgiPort;

                #Enable internal HTTP server
                #   Required for serving web interface without FastCGI
                #   and for websocket connections from client
                HTTP_SERVER = mkDefault true;

                #Port for the web interface
                #(if internal HTTP server is enabled)
                HTTP_PORT = mkDefault cfg.httpPort;

                INTERNET_PORT = mkDefault cfg.internetPort;

                #Bind HTTP server to localhost only
                HTTP_LOCALHOST_ONLY = mkDefault true;

                #Bind Internet port to localhost only
                INTERNET_LOCALHOST_ONLY = false;

                #log file name
                LOGFILE = mkDefault "/var/log/urbackup-server/urbackup.log";

                #Either debug,warn,info or error
                LOGLEVEL = mkDefault "debug";

                #Temporary file directory
                # -- this may get very large depending on the advanced settings
                DAEMON_TMPDIR = mkDefault "/tmp";

                #Tmp file directory for sqlite temporary tables.
                #You might want to put the databases on another filesystem than the other temporary files.
                #Default is the same as DAEMON_TMPDIR
                SQLITE_TMPDIR = mkDefault "";

                #Interfaces from which to send broadcasts. (Default: all).
                #Comma separated -- e.g. "eth0,eth1"
                BROADCAST_INTERFACES = mkDefault "";

                # Enable better error messages if a user cannot be found during login
                ALLOW_USER_ENUMERATION = mkDefault true;

                #User the urbackupsrv process runs as
                USER = mkDefault cfg.user;
              };

              networking.firewall = mkIf cfg.portForward {
                allowedTCPPorts = [
                  cfg.cgiPort
                  cfg.httpPort
                  cfg.internetPort
                ];
                allowedUDPPorts = [
                  # UDP broadcast to discover local clients
                  35623
                ];
              };

              systemd.services.urbackup-server = mkIf cfg.enable {
                description = "UrBackup Client/Server Network Backup System";
                after = [
                  "syslog.target"
                  "network.target"
                ];
                wantedBy = [ "multi-user.target" ];
                path = [
                  pkgs.urbackup-server
                  config.boot.zfs.package
                  # pkgs.libguestfs
                ];
                serviceConfig = {
                  User = cfg.user;
                  Group = cfg.group;
                  ExecStart = "${pkgs.urbackup-server}/bin/urbackupsrv run --config ${settingsFormat.generate "urbackupsrv" cfg.otherSettings} --no-consoletime --loglevel debug";
                  StateDirectory = "urbackup-server/urbackup";
                  WorkingDirectory = "/var/lib/urbackup-server"; # Overridden by a hardcoded path in the binary(?)
                  LogsDirectory = "urbackup-server";
                  TasksMax = "infinity";
                  # CAP_SYS_ADMIN needed to mount ZFS datasets
                  # CAP_SETUID needed to switch to root user
                  # CAP_SYS_RESOURCE needed to adjust `nice` values
                  # CAP_NET_ADMIN needed to send UDP broadcasts to find local clients
                  AmbientCapabilities = "CAP_SYS_ADMIN CAP_SETUID CAP_SYS_RESOURCE CAP_NET_ADMIN";
                };
              };
            };
          };
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
              nixpkgs.overlays = [ self.overlay ];

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
