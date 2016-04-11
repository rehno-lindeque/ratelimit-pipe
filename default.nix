{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "ratelimit-0.0.1";
  src = ./.;
  installFlags = [ "PREFIX=$(out)" ];
  meta = {
    homepage = https://github.com/rehno-lindeque/ratelimit-pipe;
    description = "Rate limit text lines in your shell pipes";
    license = stdenv.lib.licenses.unlicense;
    maintainers = [];
    buildinput = [];
    platforms = with stdenv.lib.platforms; all;
  };
}

