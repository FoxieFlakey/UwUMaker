#include <stdio.h>

#include "generated/kconfig_config.h"
#include "bruh.h"

int main() {
  printf("Hello UwU! CONFIG_CC_VERSION: %s\n", CONFIG_CC_VERSION); 
  printf("Custom msg %s\n", extra);
#ifdef CONFIG_IS_CLANG
  printf("I was compiled by clang\n");
#endif
}

