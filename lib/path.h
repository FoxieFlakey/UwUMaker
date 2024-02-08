#ifndef header_1706333875_9a9cc11f_8b0e_418f_af21_0c585bdf5adb_path_h
#define header_1706333875_9a9cc11f_8b0e_418f_af21_0c585bdf5adb_path_h

#include <stddef.h>
#include <sys/stat.h>

// Path dealing utility

// Paths stored here are always normalized
struct path {
  size_t pathLen;
  char path[];
};

struct path* path_new(const char* name);
struct path* path_new_at(const struct path* base, const char* path);
void path_free(struct path* self);

struct path* path_get_parent_dir(const struct path* self);
struct path* path_get_basename(const struct path* self);

// exactly like POSIX equivalents
int path_fs_mkdir(const struct path* self, mode_t mode);
int path_fs_open(const struct path* self, int oflag, mode_t mode);
int path_fs_remove(const struct path* self);
int path_fs_rename(const struct path* old, const struct path* new);

#define PATH_FS_STAT_FOLLOW_LINK 0x01
int path_fs_stat(const struct path* self, struct stat* stat, unsigned int flags);

#endif

