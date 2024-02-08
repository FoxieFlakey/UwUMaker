#include <cwalk.h>
#include <stdio.h>
#include <unistd.h>

#include "lib/path.h"

int main() {
  cwk_path_set_style(CWK_STYLE_UNIX);

  struct path* cwd = path_new("hello/uwu/OwO/../hi/fx/../foxie_here");
  printf("Path is %s\n", cwd->path);
  
  struct path* path = path_new_at(cwd, "hello_hi/uwu/not/root/^w^");
  printf("Path is %s\n", path->path);
  path_free(path);
  
  path = path_new_at(cwd, "/uwu/uwu/root");
  printf("Path is %s\n", path->path);
  
  struct path* tmp = path_get_basename(path);
  printf("Basename is %s\n", tmp->path);
  path_free(tmp);
  
  tmp = path_get_parent_dir(path);
  printf("Dir name is %s\n", tmp->path);
  path_free(tmp);

  printf("Path is %s\n", path->path);
  path_free(path);
  
  path_free(cwd);
}

