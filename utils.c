#include <string.h>
#include <malloc.h>
#include "HsFFI.h"

void init_haskell() {
  const char *name = "program";
  char **argv = malloc(sizeof(char*)*1);
  *argv = malloc(sizeof(char)*strlen(name) + 1);
  strcpy(*argv, name);
  int argc = 1;
  hs_init(&argc, &argv);
  free(*argv);
  free(argv);
}
