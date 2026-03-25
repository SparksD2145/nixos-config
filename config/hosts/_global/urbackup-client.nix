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
}
