#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "include/extra_lib_shared.h"

int global = 124;

int i_shouldnt_be_visible_to_other_project() {
  printf("SharedLib: From shouldn't be visible symbol\n");
  return -EPERM;
}

// Note to LTO that its in use
__attribute__((used))
__attribute__((visibility("default")))
extern int exported_shared_uwu(const char* msg) {
  printf("From shared extra lib: %s\n", msg);
  i_shouldnt_be_visible_to_other_project();
  global = msg[0];
  return strlen(msg);
}


