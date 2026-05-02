{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/x-matroska" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/x-mp3" = "mpv.desktop";
      "image/gif" = "mpv.desktop";
      "image/png" = "mpv.desktop";
      "image/jpg" = "mpv.desktop";
      "image/jpeg" = "mpv.desktop";

      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };
}
