{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Video
      "video/x-matroska" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/x-ms-wmv" = "mpv.desktop";

      # Audio
      "audio/x-wav" = "mpv.desktop";
      "audio/x-mp3" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/x-m4a" = "mpv.desktop";

      # Image
      "image/gif" = "mpv.desktop";
      "image/png" = "mpv.desktop";
      "image/jpg" = "mpv.desktop";
      "image/jpeg" = "mpv.desktop";
      "image/webp" = "mpv.desktop";
      "image/svg+xml" = "mpv.desktop";
      "image/bmp" = "mpv.desktop";

      # Code / Text → neovide
      "text/plain" = "neovide.desktop";
      "text/x-sql" = "neovide.desktop";
      "application/sql" = "neovide.desktop";
      "text/x-python" = "neovide.desktop";
      "text/javascript" = "neovide.desktop";
      "text/html" = "neovide.desktop";
      "text/css" = "neovide.desktop";
      "text/xml" = "neovide.desktop";
      "text/x-json" = "neovide.desktop";
      "text/x-markdown" = "neovide.desktop";
      "text/x-yaml" = "neovide.desktop";
      "text/x-toml" = "neovide.desktop";
      "text/x-nix" = "neovide.desktop";
      "text/x-shellscript" = "neovide.desktop";
      "text/x-c" = "neovide.desktop";
      "text/x-c++" = "neovide.desktop";
      "text/x-java" = "neovide.desktop";
      "text/x-rust" = "neovide.desktop";
      "text/x-go" = "neovide.desktop";
      "text/x-ruby" = "neovide.desktop";
      "text/x-php" = "neovide.desktop";
      "text/x-scala" = "neovide.desktop";
      "text/x-kotlin" = "neovide.desktop";
      "text/x-swift" = "neovide.desktop";
      "text/x-typescript" = "neovide.desktop";
      "text/x-dockerfile" = "neovide.desktop";
      "text/x-makefile" = "neovide.desktop";
      "text/x-csharp" = "neovide.desktop";
      "text/x-lua" = "neovide.desktop";
      "text/x-haskell" = "neovide.desktop";
      "text/x-perl" = "neovide.desktop";
      "text/x-r" = "neovide.desktop";

      # Document
      "application/pdf" = "org.pwmt.zathura.desktop";

      # Directory
      "inode/directory" = "dolphin.desktop";
    };
  };
}
