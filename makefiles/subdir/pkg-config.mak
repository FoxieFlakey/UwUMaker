# Pkg config support

ifdef IS_TOPDIR
ifneq (0,$(words $(UwUMaker-pkg-config-libs-y)))
pkg-config-all-found = $(shell pkg-config --libs $(UwUMaker-pkg-config-libs-y) | grep -o ""; echo $$?)
ifneq ($(pkg-config-all-found),"0")
$(error "pkg-config cannot find all libraries see above")
endif

UwUMaker-c-flags-y += $(shell pkg-config --cflags $(UwUMaker-pkg-config-libs-y))
UwUMaker-linker-flags-y += $(shell pkg-config --libs $(UwUMaker-pkg-config-libs-y))
endif
else
ifdef UwUMaker-pkg-config-libs-y
	$(error "Subdir must not define or use UwUMaker-pkg-config-libs-y")
endif
endif


