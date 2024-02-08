
UwUMaker-name := uwumaker2
UwUMaker-is-executable := y

UwUMaker-dirs-y += uwumaker lib

UwUMaker-c-flags-y += -std=c2x -g \
	              -Wall -Wshadow -Wpointer-arith \
                -Wmissing-prototypes \
                -fpic -fblocks -Wextra \
                -D_POSIX_C_SOURCE=200809L \
                -fvisibility=hidden -fno-common \
                -Wmissing-field-initializers \
                -Wstrict-prototypes \
                -Waddress -Wconversion -Wunused \
                -Wcast-align -Wfloat-equal -Wformat=2 \
                -fstrict-flex-arrays=3 -Warray-bounds \
                -Wno-initializer-overrides

UwUMaker-linker-flags-y += -lBlocksRuntime
UwUMaker-pkg-config-libs-y += libtoml cwalk

