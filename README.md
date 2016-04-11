# ratelimit (your shell pipes!)
A tiny POSIX utility for rate limiting text lines piped through it.

# Installation

To install from source, simply use:

```sh
make install
```

Another pleasant option is the [nix](https://nixos.org/nix/) package manager. I'm not actively maintaining this package, so I've kept it unlisted.
Never-the-less, it's simple to pull this package into your configuration directly from GitHub:

```sh
pkgs.callPackage
  ( pkgs.fetchFromGitHub
    {
      owner = "rehno-lindeque";
      repo = "ratelimit-pipe";
      rev = "0000000000000000000000000000000000000000";
      sha256 = "0000000000000000000000000000000000000000000000000000";
    }
  )
  {};
```

# Usage

    Usage: ratelimit [OPTION]
    Example: { printf "a\nb\n" ; sleep 2; printf "c\nd"; sleep 1; printf "e\nf"; } | ratelimit -f0.8

            -f, --frequency         frequency of text lines relayed per second
            --help                  display this help text and exit

## Ratelimited LiveReload

Here is a less contrived example using [entr](http://entrproject.org/) and [reload-browser](http://entrproject.org/scripts/reload-browser):

```sh
while true; do
find -name '*.html' | entr -d echo /_ | ratelimit --frequency 0.5 | while read l ; do browser-reload Firefox ; done
done
```

Or, alternatively, using [inotify-tools](https://github.com/rvoicilas/inotify-tools/wiki):

```sh
inotifywait -qrm --event close_write . | grep --line-buffered '.html$' | ratelimit --frequency 0.5 | while read l ; do browser-reload Firefox ; done
```

## Automatically reload your Haskell REPL


The same trick can be used to reload your repl

```sh
{ inotifywait -qrm --event close_write . | grep --line-buffered '.hs$' | ratelimit --frequency 0.5 | sed -ue 's/.*/:reload/g' & cat -; } | gchi
```

It is `.hs` (Haskell source) files in the current directory for changes using

# Contributing

I'm unlikely to add any new features to this utility, but please feel free to let me know if you would like to take over maintenance on this program.

