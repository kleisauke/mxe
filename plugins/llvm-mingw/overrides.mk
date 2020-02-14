# This file is part of MXE. See LICENSE.md for licensing information.

$(PLUGIN_HEADER)

IS_LLVM := $(true)

# Override sub-dependencies
cc_DEPS := llvm
llvm_DEPS := $(subst cc,llvm-mingw,$(llvm_DEPS))

# Update mingw-w64 to 816d52f
# https://github.com/mingw-w64/mingw-w64/tarball/816d52fc7225a9fa781e9f22948b791f45af1cf2
# Keep-in sync with:
# https://github.com/mstorsjo/llvm-mingw/blob/$(llvm-mingw_VERSION)/build-mingw-w64.sh#L21
mingw-w64_VERSION  := 816d52f
mingw-w64_CHECKSUM := 3aec7d49b24f3850f4c374766ba01bc62cc555d7db628f015606fe6586db9ade
mingw-w64_SUBDIR   := mingw-w64-mingw-w64-$(mingw-w64_VERSION)
mingw-w64_FILE     := mingw-w64-mingw-w64-$(mingw-w64_VERSION).tar.gz
mingw-w64_URL      := https://github.com/mingw-w64/mingw-w64/tarball/$(mingw-w64_VERSION)/$(mingw-w64_FILE)

# libc++ uses Win32 threads to implement the internal
# threading API, so we do not need to build pthreads.
define pthreads_BUILD
    $(info $(PKG) is not built when the llvm-mingw plugin is used)
endef
