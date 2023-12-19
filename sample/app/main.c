#include <stdio.h>
#include <zlib.h>
#include <errno.h>

#include "generated/kconfig_config.h"
#include "bruh.h"

#include "extra_lib_static.h"
#include "extra_lib_shared.h"

int i_shouldnt_be_visible_to_other_project() {
  printf("Main: From shouldn't be visible function\n");
  return -EPERM;
}

int main() {
  printf("Hello UwU! CONFIG_CC_VERSION: %s\n", CONFIG_CC_VERSION); 
  printf("Custom msg %s\n", extra);
#ifdef CONFIG_IS_CLANG
  printf("I was compiled by clang\n");
#endif

  printf("Dynamic linked library is Zlib %s\n", zlibVersion());
  printf("Address of deflateInit symbol is %p\n", (void*) deflate);
  
  exported_static_uwu("From main program :3");
  exported_shared_uwu("From main program :3");

  i_shouldnt_be_visible_to_other_project();
}

