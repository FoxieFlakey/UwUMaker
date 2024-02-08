#include <stdlib.h>
#include <string.h>
#include <cwalk.h>

#include "lib/path.h"

static struct path* autoResizeOrDealloc(struct path* self, size_t (^block)(struct path*)) {
  size_t bufLen = self->pathLen + 1;
  size_t writtenBytes = block(self);
  
  // Resize the struct because "block" either
  // need smaller or larger than allocated size
  if (writtenBytes != bufLen) {
    struct path* newSelf = realloc(self, sizeof(*self) + writtenBytes);
    if (!newSelf) {
      path_free(self);
      return NULL;
    }
    self = newSelf;
  }

  self->pathLen = writtenBytes - 1;
  if (writtenBytes > bufLen)
    block(self);
  return self;
}

static struct path* normalizeOrDealloc(struct path* self) {
  return autoResizeOrDealloc(self, ^size_t (struct path* self2) {
    return cwk_path_normalize(self2->path, self2->path, self2->pathLen + 1) + 1;
  });
}

static struct path* newPath(size_t expectedStringLen, size_t (^block)(struct path*)) {
  struct path* self = malloc(sizeof(*self) + expectedStringLen + 1);
  self->pathLen = expectedStringLen;
  return normalizeOrDealloc(autoResizeOrDealloc(self, block));
}


struct path* path_new(const char* path) {
  size_t pathLen = strlen(path);
  return newPath(pathLen, ^size_t (struct path* self) {
    memcpy(self->path, path, pathLen + 1);
    return pathLen;
  });
}

struct path* path_new_at(const struct path* relativeTo, const char* path) {
  size_t pathLen = relativeTo->pathLen + strlen(path);
  return newPath(pathLen, ^size_t (struct path* self) {
    return cwk_path_join(relativeTo->path, path, self->path, self->pathLen + 1) + 1;
  });
}

void path_free(struct path* self) {
  free(self);
}

struct path* path_get_parent_dir(const struct path* self) {
  size_t dirNameLength;
  cwk_path_get_dirname(self->path, &dirNameLength);
  return newPath(dirNameLength, ^size_t (struct path* self2) {
    memcpy(self2->path, self->path, dirNameLength + 1);
    return dirNameLength;
  });
}

struct path* path_get_basename(const struct path* self) {
  size_t basenameLength;
  const char* basename;
  cwk_path_get_basename(self->path, &basename, &basenameLength);
  return newPath(basenameLength, ^size_t (struct path* self2) {
    memcpy(self2->path, basename, basenameLength + 1);
    return basenameLength + 1;
  });
}





