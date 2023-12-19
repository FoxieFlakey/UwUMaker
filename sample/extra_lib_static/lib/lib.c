#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "include/extra_lib_static.h"

int i_shouldnt_be_visible_to_other_project() {
  printf("StaticLib: From shouldn't be visible function\n");
  return -EPERM;
}

// Note to LTO that its in use
__attribute__((used))
__attribute__((visibility("default")))
extern int exported_static_uwu(const char* msg) {
  printf("From static extra lib: %s\n", msg);
  i_shouldnt_be_visible_to_other_project();
  return strlen(msg);
}

