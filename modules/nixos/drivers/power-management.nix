{ lib, ... }:
let
  # TODO: move setting to config file
  power_management_tool = "tlp";
in
{
  # Enable NixOS power management services
  # This tool is compatible with the other tools like tpl, but the other tools may overwrite this setting.
  powerManagement.enable = true;

  # tlp and power-profiles-daemon services conflict with each other
  # Either one or the other can be enabled, but not both
  services.power-profiles-daemon.enable = lib.mkForce false;

  # Enable tlp power management tool, which can help extend battery life on laptops
  # For configuring power management settings, see https://linrunner.de/tlp/settings/introduction.html
  services.tlp = lib.mkIf (power_management_tool == "tlp") {
    enable = true;
    settings = {
      # Timeout (in seconds) for the audio power saving mode (supports Intel HDA, AC97).
      # A value of 1 is recommended for Linux desktop environments with PulseAudio, systems without PulseAudio may require 10.
      # The value 0 disables power save.
      # TODO: Check whether we're running a desktop environment with PulseAudio before setting this value
      SOUND_POWER_SAVE_ON_AC = 10;
      SOUND_POWER_SAVE_ON_BAT = 10;

      # CPU configuration
      # Selects a CPU scaling driver operation mode. Possible values are "active" and "passive".
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";

      # Selects the CPU scaling governor for automatic frequency scaling.
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Set CPU energy/performance policies (in order of increasing power saving):
      # - performance: maximum performance
      # - balance-performance: balanced performance
      # - default: default performance
      # - balance-power: balanced power saving
      # - power: maximum power saving
      CPU_ENERGY_PREF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PREF_POLICY_ON_BAT = "power";

      # Define the min/max P-state for Intel CPUs. Values are stated as a percentage (0..100%) of the total available processor performance.
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 80;

      # Configure CPU “turbo boost” (Intel) or “turbo core” (AMD) feature
      # A value of 1 does not activate boosting, it just allows it.
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Configure the Intel CPU HWP dynamic boost feature:
      # Requires: Intel Core i 6th gen. (“Skylake”) or newer CPU with intel_pstate scaling driver in active mode
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Battery charge thresholds
      # Battery charge level below which charging will begin when connecting the charger.
      START_CHARGE_THRESH_BAT0 = 25;
      # Battery charge level above which charging will stop while the charger is connected.
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  # Enable auto-cpufreq power management tool
  # This tool is not compatible with tlp so either one or the other can be enabled, but not both
  # For configuring power management settings, see https://github.com/AdnanHodzic/auto-cpufreq/blob/v1.9.9/auto-cpufreq.conf-example
  services.auto-cpufreq = lib.mkIf (power_management_tool == "auto-cpufreq") {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
