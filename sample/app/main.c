#include <stdio.h>
#include <zlib.h>

#include "generated/kconfig_config.h"
#include "bruh.h"

int main() {
  printf("Hello UwU! CONFIG_CC_VERSION: %s\n", CONFIG_CC_VERSION); 
  printf("Custom msg %s\n", extra);
#ifdef CONFIG_IS_CLANG
  printf("I was compiled by clang\n");
#endif

  printf("Dynamic linked library is Zlib %s\n", zlibVersion());
  printf("Address of deflateInit symbol is %p\n", (void*) deflate);
}

