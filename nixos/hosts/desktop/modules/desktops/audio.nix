{ config, pkgs, lib, ... }: {

  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  hardware.bluetooth.settings = {
    General.Enable = "Source,Sink,Media,Socket";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = false;
    media-session.enable = true;

    media-session.config.alsa-monitor = 

    config.pipewire = {
      "context.properties" = {
        # version < 3 clients can't handle more than 16 buffers
        "link.max-buffers" = 16;
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 ];
        "log.level" = 0;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          flags = [ "ifexists" "nofail" ];
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "audio.position" = [ "FL" "FR" ];
            "capture.props" = {
              "media.class" = "Audio/Sink";
              "node.name" = "music_sink";
              "node.description" = "Music Sink";
            };
            "playback.props" = {
              "node.name" = "";
            };
          };
        }
      ];
    };
  };

  hardware.pulseaudio.enable = false;
}
