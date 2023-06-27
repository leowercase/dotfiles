{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.audio;
  in
  {
    options.custom.audio = mkOption {
      type = with types; nullOr (enum [ "alsa" "pulseaudio" "pipewire" ]);
      default = null;
      description =
        "Should bare ALSA, PulseAudio or Pipewire be used for audio, or no audio in the case of a `null` value.";
    };

    config = {
      # Bare ALSA
      sound.enable = cfg == "alsa";

      # PulseAudio
      hardware.pulseaudio = mkIf (cfg == "pulseaudio") {
        enable = true;
        support32Bit = true;
      };

      # PipeWire
      services.pipewire = mkIf (cfg == "pipewire") {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
      };

      # PipeWire and PulseAudio both use RealtimeKit
      security.rtkit.enable = (cfg == "pulseaudio") || (cfg == "pipewire");
    };
  }
