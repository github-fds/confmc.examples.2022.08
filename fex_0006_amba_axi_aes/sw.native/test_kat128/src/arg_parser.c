//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved.
// http://www.future-ds.com
//------------------------------------------------------------------------------
// VERSION = 2018.04.27.
//------------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <assert.h>
#include <sys/types.h>
#include <fcntl.h>
#ifdef WIN32
#	include <windows.h>
#	include <io.h>
#endif
#include "conapi.h"

int verbose = 0;

extern void help(int, char **);
extern unsigned int card_id;
extern int level;
extern int entry_num;

/*----------------------------------------------------------------------------
 * 1. get simulator options from command line
 * 2. returns the argv index for the program options
 */
#define XXTX\
	if ((i+1)>=argc) {\
	fprintf(stderr, "Error: need more for %s option\n", argv[i]);\
	exit(1);}
int arg_parser(int argc, char **argv) {
  int i;
  char *cpt;

  /*
   * get simulator options from command argument
   */
  for (i=1; i<argc; i++) {
           if (!strcmp(argv[i], "-c")) { XXTX
        card_id = atoi(argv[++i]);
    } else if (!strcmp(argv[i], "-n")) { XXTX
        entry_num = (int)strtol(argv[++i], NULL, 0);
    } else if (!strcmp(argv[i], "-v")) { XXTX
        verbose = (int)strtol(argv[++i], NULL, 0);
    } else if (!strcmp(argv[i], "-h")||!strcmp(argv[i], "-?")) {
	help(argc, argv);
	exit(0);
    } else if (argv[i][0]=='-') {
	fprintf(stderr, "undefined option: %s\n", argv[i]);
	help(argc, argv);
	exit(1);
    } else break;
  }
  return i;
}
#undef XXTX

/*----------------------------------------------------------------------------
 *
 */
void
help(int argc, char **argv) {
  extern unsigned int card_id;
  extern int          verbose;
  extern int          level;

  fprintf(stderr, "[Usage] %s [options]\n", argv[0]);
  fprintf(stderr, "\t-c   cid    card id: %d\n", card_id);
  fprintf(stderr, "\t-n   num    num of entries: %d (1-128)\n", entry_num);
  fprintf(stderr, "\t-v   num    verbose level (default: %d)\n", verbose);
  fprintf(stderr, "\t-h          print help message\n");
}

void sig_handle(int sig) {
  extern void cleanup();
  switch (sig) {
  case SIGINT:
  #ifndef WIN32
  case SIGQUIT:
  #endif
       cleanup();
       exit(0);
       break;
  }
}

void cleanup(void) {
  fflush(stdout); fflush(stderr);
}

//------------------------------------------------------------------------------
// Revision History
//
// 2018.04.27: Start by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
