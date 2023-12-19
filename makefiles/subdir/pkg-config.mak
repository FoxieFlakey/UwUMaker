# Pkg config support

ifdef IS_TOPDIR
ifneq (0,$(words $(UwUMaker-pkg-config-libs-y)))
UwUMaker-c-flags-y += $(shell pkg-config --cflags $(UwUMaker-pkg-config-libs-y))
UwUMaker-linker-flags-y += $(shell pkg-config --libs $(UwUMaker-pkg-config-libs-y))
endif
else
ifdef UwUMaker-pkg-config-libs-y
	$(error "Subdir must not define or use UwUMaker-pkg-config-libs-y")
endif
endif


