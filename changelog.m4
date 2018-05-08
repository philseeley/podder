podder (__VERSION__-__RELEASE__) stable; urgency=low

  * 1.6 1 We now use curl so that https feeds can be supported.
          xsltproc doesn't support SSL/TLS.
  * 1.5 2 Fix the removal the bad characters from the filenames
          We now only allow "a-zA-Z0.9_-" in the filenames rather than trying to specify all the bad characters.
  * 1.5 1 Added +n option
          This allows playlists (.m3u) files to be given the name of the containing directory.
  * 1.4 1 Added +a option
          This allows playlists (podder.m3u) files to be written alphabetically.
  * 1.3 1 Added -p option
          This allows playlists (podder.m3u) files to be suppressed.
  * 1.2 1 Empty lock files are now handled correctly
          Lock files are also correctly placed with the config files.
  * 1.1 1 Added locking
          This stops a config file from being processed multiple times.
  * 1.0 1 Initial release

 -- Phil Seeley <phil.seeley@gmail.com>  __DATE__

