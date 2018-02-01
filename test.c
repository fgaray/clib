#include <stdio.h>
#include <dlfcn.h>

struct functions_struct {
  void (*test)(void);
  void (*init_haskell)(void);
  void (*add_function_testFFI)(void (void*));
  void *handle;
};


#define load(S)\
  functions.S = dlsym(functions.handle, "" #S);\
  if (!functions.S) { \
    printf("Can't open " #S "\n"); \
    return -1; \
  }


void testFFI() {
  printf("Hello FFI!\n");
}
  

int main() {
  struct functions_struct functions;
    
  functions.handle = dlopen("./htesting.so", RTLD_LAZY);
  if (!functions.handle) {
    printf("Cant open handle: %s\n", dlerror());
    return -1;
  }

  load(init_haskell)
  (*functions.init_haskell)();

  load(add_function_testFFI);
  (*functions.add_function_testFFI)(&testFFI);

  load(test);
  (*functions.test)();

  return 0;
}
