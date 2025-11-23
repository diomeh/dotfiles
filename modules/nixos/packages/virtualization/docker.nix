{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Docker daemon
  # This does not enables docker desktop as it is not available on NixOS.
  # A good alternative is portainer, see https://www.portainer.io

  # Enable docker in root mode
  # INFO: Beware that the docker group membership is effectively equivalent to being root!
  # See: https://github.com/moby/moby/issues/9976
  # Consider enabling docker in rootless mode
  virtualisation.docker.enable = true;

  # Enable docker daemon in rootless mode
  # virtualisation.docker.rootless = {
  #   enable = true;

  #   # The setSocketVariable option sets the DOCKER_HOST variable to the rootless Docker instance for normal users by default.
  #   setSocketVariable = true;
  # };

  # Add the current user to the docker group
  users.users."${config.users.default.username}".extraGroups = [ "docker" ];

  # Force disable docker service so that it is not started on boot
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    docker-buildx # Docker CLI plugin for extended build capabilities with BuildKit
  ];
}
