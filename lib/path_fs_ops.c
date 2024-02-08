#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>

#include "lib/path.h"

int path_fs_mkdir(const struct path* self, mode_t mode) {
  return mkdir(self->path, mode);
}

int path_fs_open(const struct path* self, int oflag, mode_t mode) {
  return open(self->path, oflag, mode);
}

int path_fs_remove(const struct path* self) {
  return remove(self->path);
}

int path_fs_rename(const struct path* old, const struct path* new) {
  return rename(old->path, new->path);
}

int path_fs_stat(const struct path* self, struct stat* statPtr, unsigned int flags) {
  if (flags & PATH_FS_STAT_FOLLOW_LINK)
    return stat(self->path, statPtr);
  return lstat(self->path, statPtr);
}

