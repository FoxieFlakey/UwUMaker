#include <stdio.h>

#include "generated/kconfig_config.h"

#include "extra_lib_static.h"
#include "extra_lib_shared.h"

int main() {
  printf("From helper program! CONFIG_CC_VERSION: %s\n", CONFIG_CC_VERSION); 
#ifdef CONFIG_IS_CLANG
  printf("I was compiled by clang\n");
#endif

  exported_static_uwu("From helper program :3");
  exported_shared_uwu("From helper program UwI");
}

