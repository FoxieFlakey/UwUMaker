#ifndef header_1706340782_7009f6f9_8f36_4ffb_b9c0_83419637bde5_refcount_h
#define header_1706340782_7009f6f9_8f36_4ffb_b9c0_83419637bde5_refcount_h

#include <stdatomic.h>

struct refcount {
  atomic_uint_fast64_t counter;
};

#define REFCOUNT_INITIALIZER (struct refcount) {.counter = 1}

static inline void refcount_acquire(struct refcount* self) {
  atomic_fetch_add(&self->counter, 1);
}

static inline bool refcount_release(struct refcount* self) {
  return atomic_fetch_sub(&self->counter, 1) == 0;
}

#endif

