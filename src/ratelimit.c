/* Rate limit lines being piped through this program (by dropping lines inside the threshold value)
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdbool.h>
#include <float.h>

#if(__STDC_VERSION__ >= 20112L)
#define USE_TIMESPEC
double difftimespec(struct timespec *stop, struct timespec *start)
{
  double dsec = difftime(stop->tv_sec, start->tv_sec);
  long dnsec = stop->tv_nsec - start->tv_nsec;
  if (dnsec < 0) {
    return (dsec - 1) + (dnsec + 1000000000) / 1000000000.0;
  } else {
    return dsec + dnsec / 1000000000.0;
  }
}
#endif

void version() {
  printf("ratelimit " RELEASE "\n");
  printf("https://github.com/rehno-lindeque/ratelimit-pipe");
  printf("\n");
}

void usage() {
  printf("Usage: ratelimit [OPTION]\n");
  printf("Example: { printf \"a\\nb\\n\" ; sleep 2; printf \"c\\nd\"; sleep 1; printf \"e\\nf\"; } | ratelimit -f 0.8\n");
  printf("\n\t-f, --frequency\t\tfrequency of text lines relayed per second");
  printf("\n\t--help\t\t\tdisplay this help text and exit");
  printf("\n");
}

int main(int argc, const char **argv){
  char buffer[4096]; /* According to http://stackoverflow.com/a/2879610/167486 POSIX suggests a line length of 4096 */
  double interval = 1.0;
  char *pend = NULL;
  int c = 0;
  const char *freqs = NULL;
  double freq = 0;
#ifdef USE_TIMESPEC
  struct timespec last;
  struct timespec now;
#else
  time_t last = 0;
  time_t now = 0;
#endif

  for (c = 1 ; c < argc ; ++c) {
    if (strcmp(argv[c], "--version") == 0) {
      version();
      return 0;
    }
    if (strcmp(argv[c], "--help") == 0) {
      usage();
      return 0;
    }
    else if ((c < argc - 1 && (strcmp(argv[c], "-f") == 0 || strcmp(argv[c], "--frequency") == 0)) || (argv[c][0] == '-' && argv[c][1] == 'f' && argv[c][2] >= '0' && argv[c][2] <= '9')) {
      if (argv[c][2] >= '0' && argv[c][2] <= '9') {
        freqs = &argv[c][2];
      }
      else {
        freqs = argv[c + 1];
      }
      freq = strtod(freqs, &pend);
      if (freq < DBL_EPSILON) {
        fprintf(stderr, "Frequency argument %f is out of range (expected a floating-point number larger than 0)\n", freq);
        usage();
        return 1;
      }
      else if (pend == NULL || *pend != '\0') {
        fprintf(stderr, "Could not parse frequency argument %s (expected an floating-point number larger than 0)\n", argv[c + 1]);
        usage();
        return 1;
      }
      interval = 1.0 / freq;
      c += 1;
    }
    else {
      fprintf(stderr, "Unrecognized argument %s\n", argv[c]);
      usage();
      return 1;
    }
  }

  setvbuf(stdout,NULL,_IOLBF,256);
  while (fgets(buffer, sizeof(buffer), stdin) != NULL) {
#ifdef USE_TIMESPEC
    timespec_get(&now, TIME_UTC);
    if (difftimespec(&now, &last) >= interval) {
#else
    time(&now);
    if (difftime(now, last) >= interval) {
#endif
      printf(buffer);
      last = now;
    }
  }

  return 0;
}

