#include <stdio.h>

[[gnu::weak]]
extern void common();

int main() {
  printf("Hello world! Compiled by UwUMaker\n");
  if (common)
    common();
}



